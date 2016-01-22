//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: Transformer Base

public class Transformer<InputType, OutputType> {
    
    internal let map: Map
    internal let transformer: InputType? throws -> OutputType

    private var allowsNil: Bool
    
    public init(map: Map, transformer: InputType throws -> OutputType) {
        self.map = map
        self.transformer = { input in
            return try transformer(input!)
        }
        self.allowsNil = false
    }
    
    public init(map: Map, transformer: InputType? throws -> OutputType) {
        self.map = map
        self.transformer = transformer
        self.allowsNil = true
    }
    
    internal func transformValue<T>(value: T) throws -> OutputType {
        if let input = value as? InputType {
            return try transformer(input)
        } else {
            throw logError(unexpectedInput(value))
        }
    }
    
    internal func transformValue<T>(value: T?) throws -> OutputType {
        if allowsNil {
            guard let unwrapped = value else { return try transformer(nil) }
            return try transformValue(unwrapped)
        } else {
            let unwrapped = try enforceValueExists(value)
            return try transformValue(unwrapped)
        }
        
    }
    
    private func unexpectedInput<ValueType>(value: ValueType) -> ErrorType {
        let message = "Unexpected Input: \(value) ofType: \(ValueType.self) Expected: \(InputType.self) KeyPath: \(map.lastKey)"
        return TransformationError.UnexpectedInputType(message)
    }
    
    private func enforceValueExists<T>(value: T?) throws -> T {
        if let unwrapped = value {
            return unwrapped
        } else {
            let error = TransformationError.UnexpectedInputType("Unexpectedly found nil input.  KeyPath: \(map.lastKey) Expected: \(InputType.self)")
            throw logError(error)
        }
    }
}


// MARK: From Node

public final class FromNodeTransformer<NodeType: NodeConvertibleType, TransformedType> : Transformer<NodeType, TransformedType> {
    override public init(map: Map, transformer: NodeType throws -> TransformedType) {
        super.init(map: map, transformer: transformer)
    }
    
    override public init(map: Map, transformer: NodeType? throws -> TransformedType) {
        super.init(map: map, transformer: transformer)
    }
    
    public func transformToNode<OutputNodeType: NodeConvertibleType>(transformer: TransformedType throws -> OutputNodeType) -> TwoWayTransformer<NodeType, TransformedType, OutputNodeType> {
        let toNodeTransformer = ToNodeTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromNodeTransformer: self, toNodeTransformer: toNodeTransformer)
    }
    
    internal func transformValue(node: Node?) throws -> TransformedType {
        let validNode: Node
        if allowsNil {
            guard let unwrapped = node else { return try transformer(nil) }
            validNode = unwrapped
        } else {
            validNode = try enforceValueExists(node)
        }
        
        let input = try NodeType.newInstance(validNode, context: validNode)
        return try transformer(input)
    }
}

// MARK: To Node

public final class ToNodeTransformer<ValueType, OutputNodeType: NodeConvertibleType> : Transformer<ValueType, OutputNodeType> {
    override public init(map: Map, transformer: ValueType throws -> OutputNodeType) {
        super.init(map: map, transformer: transformer)
    }
    
    func transformFromNode<InputNodeType>(transformer: InputNodeType throws -> ValueType) -> TwoWayTransformer<InputNodeType, ValueType, OutputNodeType> {
        let fromNodeTransformer = FromNodeTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromNodeTransformer: fromNodeTransformer, toNodeTransformer: self)
    }
    
    func transformFromNode<InputNodeType>(transformer: InputNodeType? throws -> ValueType) -> TwoWayTransformer<InputNodeType, ValueType, OutputNodeType> {
        let fromNodeTransformer = FromNodeTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromNodeTransformer: fromNodeTransformer, toNodeTransformer: self)
    }
    
    internal func transformValue(value: ValueType) throws -> Node {
        let transformed = try transformer(value)
        return try transformed.nodeRepresentation()
    }
}

// MARK: Two Way Transformer

public final class TwoWayTransformer<InputNodeType: NodeConvertibleType, TransformedType, OutputNodeType: NodeConvertibleType> {
    
    var map: Map {
        let toMap = toNodeTransformer.map
        return toMap
    }
    
    public let fromNodeTransformer: FromNodeTransformer<InputNodeType, TransformedType>
    public let toNodeTransformer: ToNodeTransformer<TransformedType, OutputNodeType>
    
    public init(fromNodeTransformer: FromNodeTransformer<InputNodeType, TransformedType>, toNodeTransformer: ToNodeTransformer<TransformedType, OutputNodeType>) {
        self.fromNodeTransformer = fromNodeTransformer
        self.toNodeTransformer = toNodeTransformer
    }
}

// MARK: Map Extensions

public extension Map {
    public func transformFromNode<NodeType: NodeConvertibleType, TransformedType>(transformer: NodeType throws -> TransformedType) -> FromNodeTransformer<NodeType, TransformedType> {
        return FromNodeTransformer(map: self, transformer: transformer)
    }
    
    public func transformFromNode<NodeType: NodeConvertibleType, TransformedType>(transformer: NodeType? throws -> TransformedType) -> FromNodeTransformer<NodeType, TransformedType> {
        return FromNodeTransformer(map: self, transformer: transformer)
    }
    
    public func transformToNode<ValueType, NodeOutputType: NodeConvertibleType>(transformer: ValueType throws -> NodeOutputType) -> ToNodeTransformer<ValueType, NodeOutputType> {
        return ToNodeTransformer(map: self, transformer: transformer)
    }
}

// MARK: Operators

public func <~> <T: NodeConvertibleType, NodeInputType>(inout lhs: T, rhs: FromNodeTransformer<NodeInputType, T>) throws {
    switch rhs.map.type {
    case .FromNode:
        try lhs <~ rhs
    case .ToNode:
        try lhs ~> rhs.map
    }
}

public func <~> <T: NodeConvertibleType, NodeOutputType: NodeConvertibleType>(inout lhs: T, rhs: ToNodeTransformer<T, NodeOutputType>) throws {
    switch rhs.map.type {
    case .FromNode:
        try lhs <~ rhs.map
    case .ToNode:
        try lhs ~> rhs
    }
}

public func <~> <NodeInput, TransformedType, NodeOutput: NodeConvertibleType>(inout lhs: TransformedType, rhs: TwoWayTransformer<NodeInput, TransformedType, NodeOutput>) throws {
    switch rhs.map.type {
    case .FromNode:
        try lhs <~ rhs.fromNodeTransformer
    case .ToNode:
        try lhs ~> rhs.toNodeTransformer
    }
}

public func <~ <T, NodeInputType: NodeConvertibleType>(inout lhs: T, rhs: FromNodeTransformer<NodeInputType, T>) throws {
    switch rhs.map.type {
    case .FromNode:
        try lhs = rhs.transformValue(rhs.map.result)
    case .ToNode:
        break
    }
}

public func ~> <T, NodeOutputType: NodeConvertibleType>(lhs: T, rhs: ToNodeTransformer<T, NodeOutputType>) throws {
    switch rhs.map.type {
    case .FromNode:
        break
    case .ToNode:
        let output = try rhs.transformValue(lhs)
        try rhs.map.setToLastKey(output)
    }
}
