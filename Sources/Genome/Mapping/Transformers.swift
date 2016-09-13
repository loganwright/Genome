// MARK: Transformer Base

open class Transformer<InputType, OutputType> {
    internal let map: Map
    internal let transformer: (InputType?) throws -> OutputType

    public init(map: Map, transformer: @escaping (InputType) throws -> OutputType) {
        self.map = map
        self.transformer = { input in
            guard let unwrapped = input else {
                // TODO: Own Error?
                throw NodeError.unableToConvert(node: nil, expected: "\(InputType.self)")
            }
            return try transformer(unwrapped)
        }
    }
    
    public init(map: Map, transformer: @escaping (InputType?) throws -> OutputType) {
        self.map = map
        self.transformer = transformer
    }

    internal func transform(_ value: InputType?) throws -> OutputType {
        return try transformer(value)
    }
}


// MARK: From Node

public final class FromNodeTransformer<ConvertibleInput: NodeConvertible, TransformedOutput>
                   : Transformer<ConvertibleInput, TransformedOutput> {
    override public init(map: Map, transformer: @escaping (ConvertibleInput) throws -> TransformedOutput) {
        super.init(map: map, transformer: transformer)
    }
    
    override public init(map: Map, transformer: @escaping (ConvertibleInput?) throws -> TransformedOutput) {
        super.init(map: map, transformer: transformer)
    }

    public func transformToNode
        <OutputNodeType: NodeConvertible>(
        with transformer: @escaping (TransformedOutput) throws -> OutputNodeType)
        -> TwoWayTransformer<ConvertibleInput, TransformedOutput, OutputNodeType> {
            let toNodeTransformer = ToNodeTransformer(map: map, transformer: transformer)
            return TwoWayTransformer(fromNodeTransformer: self,
                                     toNodeTransformer: toNodeTransformer)
    }
    
    internal func transform(_ node: Node?) throws -> TransformedOutput {
        if let node = node {
            let input = try ConvertibleInput.init(node: node, in: node)
            return try transform(input)
        } else {
            return try transform(Optional<ConvertibleInput>.none)
        }
    }
}

// MARK: To Node

public final class ToNodeTransformer<Input, ConvertibleOutput: NodeConvertible>
                   : Transformer<Input, ConvertibleOutput> {

    override public init(map: Map, transformer: @escaping (Input) throws -> ConvertibleOutput) {
        super.init(map: map, transformer: transformer)
    }
    
    public func transformFromNode
        <InputNodeType: NodeConvertible>
        (with transformer: @escaping (InputNodeType) throws -> Input)
        -> TwoWayTransformer<InputNodeType, Input, ConvertibleOutput> {
            let fromNodeTransformer = FromNodeTransformer(map: map, transformer: transformer)
            return TwoWayTransformer(fromNodeTransformer: fromNodeTransformer,
                                     toNodeTransformer: self)
    }
    
    public func transformFromNode
        <InputNodeType: NodeConvertible>
        (with transformer: @escaping (InputNodeType?) throws -> Input)
        -> TwoWayTransformer<InputNodeType, Input, ConvertibleOutput> {
            let fromNodeTransformer = FromNodeTransformer(map: map, transformer: transformer)
            return TwoWayTransformer(fromNodeTransformer: fromNodeTransformer,
                                     toNodeTransformer: self)
    }
    
    internal func transform(_ value: Input) throws -> Node {
        let transformed = try transformer(value)
        return try transformed.makeNode()
    }
}

// MARK: Two Way Transformer

public final class TwoWayTransformer<InputNodeType: NodeConvertible,
                                     TransformedType,
                                     OutputNodeType: NodeConvertible> {
    var map: Map {
        let toMap = toNodeTransformer.map
        return toMap
    }

    public let fromNodeTransformer: FromNodeTransformer<InputNodeType, TransformedType>
    public let toNodeTransformer: ToNodeTransformer<TransformedType, OutputNodeType>

    public init(fromNodeTransformer: FromNodeTransformer<InputNodeType, TransformedType>,
                toNodeTransformer: ToNodeTransformer<TransformedType, OutputNodeType>) {
        self.fromNodeTransformer = fromNodeTransformer
        self.toNodeTransformer = toNodeTransformer
    }
}

// MARK: Map Extensions

public extension Map {
    public func transformFromNode
        <NodeType: NodeConvertible, TransformedType>
        (with transformer: @escaping (NodeType) throws -> TransformedType)
        -> FromNodeTransformer<NodeType, TransformedType> {
            return FromNodeTransformer(map: self, transformer: transformer)
    }
    
    public func transformFromNode
        <NodeType: NodeConvertible, TransformedType>
        (with transformer: @escaping (NodeType?) throws -> TransformedType)
        -> FromNodeTransformer<NodeType, TransformedType> {
            return FromNodeTransformer(map: self, transformer: transformer)
    }
    
    public func transformToNode
        <ValueType, NodeOutputType: NodeConvertible>
        (with transformer: @escaping (ValueType) throws -> NodeOutputType)
        -> ToNodeTransformer<ValueType, NodeOutputType> {
            return ToNodeTransformer(map: self, transformer: transformer)
    }
}

// MARK: Operators

public func <~> <T: NodeConvertible, NodeInputType>
    (lhs: inout T, rhs: FromNodeTransformer<NodeInputType, T>) throws {

    switch rhs.map.type {
    case .fromNode:
        try lhs <~ rhs
    case .toNode:
        try lhs ~> rhs.map
    }
}

public func <~> <T: NodeConvertible, NodeOutputType: NodeConvertible>
    (lhs: inout T, rhs: ToNodeTransformer<T, NodeOutputType>) throws {

    switch rhs.map.type {
    case .fromNode:
        try lhs <~ rhs.map
    case .toNode:
        try lhs ~> rhs
    }
}

public func <~> <NodeInput, TransformedType, NodeOutput: NodeConvertible>
    (lhs: inout TransformedType,
     rhs: TwoWayTransformer<NodeInput, TransformedType, NodeOutput>) throws {

    switch rhs.map.type {
    case .fromNode:
        try lhs <~ rhs.fromNodeTransformer
    case .toNode:
        try lhs ~> rhs.toNodeTransformer
    }
}

public func <~ <T, NodeInputType: NodeConvertible>
    (lhs: inout T, rhs: FromNodeTransformer<NodeInputType, T>) throws {

    switch rhs.map.type {
    case .fromNode:
        try lhs = rhs.transform(rhs.map.result)
    case .toNode:
        break
    }
}

public func ~> <T, NodeOutputType: NodeConvertible>
    (lhs: T, rhs: ToNodeTransformer<T, NodeOutputType>) throws {

    switch rhs.map.type {
    case .fromNode:
        break
    case .toNode:
        let output = try rhs.transform(lhs)
        try rhs.map.setToLastPath(output)
    }
}
