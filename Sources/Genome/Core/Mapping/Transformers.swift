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
    
    internal func transform(_ value: InputType) throws -> OutputType {
        return try transformer(value)
    }
    
    internal func transform(_ value: InputType?) throws -> OutputType {
        if allowsNil {
            guard let unwrapped = value else { return try transformer(nil) }
            return try transform(unwrapped)
        } else {
            let unwrapped = try enforceExists(value: value)
            return try transform(unwrapped)
        }
    }
    
    private func enforceExists<T>(value: T?) throws -> T {
        if let unwrapped = value {
            return unwrapped
        } else {
            let error = TransformationError.UnexpectedInputType("Unexpectedly found nil input.  KeyPath: \(map.lastKey) Expected: \(InputType.self)")
            throw log(error)
        }
    }
}


// MARK: From Node

public final class FromNodeTransformer<NodeType: NodeConvertible, TransformedType> : Transformer<NodeType, TransformedType> {
    override public init(map: Map, transformer: NodeType throws -> TransformedType) {
        super.init(map: map, transformer: transformer)
    }
    
    override public init(map: Map, transformer: NodeType? throws -> TransformedType) {
        super.init(map: map, transformer: transformer)
    }
    
    public func transformToNode<OutputNodeType: NodeConvertible>(with transformer: TransformedType throws -> OutputNodeType) -> TwoWayTransformer<NodeType, TransformedType, OutputNodeType> {
        let toNodeTransformer = ToNodeTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromNodeTransformer: self, toNodeTransformer: toNodeTransformer)
    }
    
    internal func transform(_ node: Node?) throws -> TransformedType {
        let validNode: Node
        if allowsNil {
            guard let unwrapped = node else { return try transformer(nil) }
            validNode = unwrapped
        } else {
            validNode = try enforceExists(value: node)
        }
        
        let input = try NodeType.init(with: validNode, in: validNode)
        return try transformer(input)
    }
}

// MARK: To Node

public final class ToNodeTransformer<ValueType, OutputNodeType: NodeConvertible> : Transformer<ValueType, OutputNodeType> {
    override public init(map: Map, transformer: ValueType throws -> OutputNodeType) {
        super.init(map: map, transformer: transformer)
    }
    
    public func transformFromNode<InputNodeType: NodeConvertible>(with transformer: InputNodeType throws -> ValueType) -> TwoWayTransformer<InputNodeType, ValueType, OutputNodeType> {
        let fromNodeTransformer = FromNodeTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromNodeTransformer: fromNodeTransformer, toNodeTransformer: self)
    }
    
    public func transformFromNode<InputNodeType: NodeConvertible>(with transformer: InputNodeType? throws -> ValueType) -> TwoWayTransformer<InputNodeType, ValueType, OutputNodeType> {
        let fromNodeTransformer = FromNodeTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromNodeTransformer: fromNodeTransformer, toNodeTransformer: self)
    }
    
    internal func transform(_ value: ValueType) throws -> Node {
        let transformed = try transformer(value)
        return try transformed.toNode()
    }
}

// MARK: Two Way Transformer

public final class TwoWayTransformer<InputNodeType: NodeConvertible, TransformedType, OutputNodeType: NodeConvertible> {
    
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
    public func transformFromNode<NodeType: NodeConvertible, TransformedType>(with transformer: NodeType throws -> TransformedType) -> FromNodeTransformer<NodeType, TransformedType> {
        return FromNodeTransformer(map: self, transformer: transformer)
    }
    
    public func transformFromNode<NodeType: NodeConvertible, TransformedType>(with transformer: NodeType? throws -> TransformedType) -> FromNodeTransformer<NodeType, TransformedType> {
        return FromNodeTransformer(map: self, transformer: transformer)
    }
    
    public func transformToNode<ValueType, NodeOutputType: NodeConvertible>(with transformer: ValueType throws -> NodeOutputType) -> ToNodeTransformer<ValueType, NodeOutputType> {
        return ToNodeTransformer(map: self, transformer: transformer)
    }
}

// MARK: Operators

public func <~> <T: NodeConvertible, NodeInputType>(lhs: inout T, rhs: FromNodeTransformer<NodeInputType, T>) throws {
    switch rhs.map.type {
    case .FromNode:
        try lhs <~ rhs
    case .ToNode:
        try lhs ~> rhs.map
    }
}

public func <~> <T: NodeConvertible, NodeOutputType: NodeConvertible>(lhs: inout T, rhs: ToNodeTransformer<T, NodeOutputType>) throws {
    switch rhs.map.type {
    case .FromNode:
        try lhs <~ rhs.map
    case .ToNode:
        try lhs ~> rhs
    }
}

public func <~> <NodeInput, TransformedType, NodeOutput: NodeConvertible>(lhs: inout TransformedType, rhs: TwoWayTransformer<NodeInput, TransformedType, NodeOutput>) throws {
    switch rhs.map.type {
    case .FromNode:
        try lhs <~ rhs.fromNodeTransformer
    case .ToNode:
        try lhs ~> rhs.toNodeTransformer
    }
}

public func <~ <T, NodeInputType: NodeConvertible>(lhs: inout T, rhs: FromNodeTransformer<NodeInputType, T>) throws {
    switch rhs.map.type {
    case .FromNode:
        try lhs = rhs.transform(rhs.map.result)
    case .ToNode:
        break
    }
}

public func ~> <T, NodeOutputType: NodeConvertible>(lhs: T, rhs: ToNodeTransformer<T, NodeOutputType>) throws {
    switch rhs.map.type {
    case .FromNode:
        break
    case .ToNode:
        let output = try rhs.transform(lhs)
        try rhs.map.setToLastKey(output)
    }
}
