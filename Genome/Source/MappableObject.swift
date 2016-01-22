//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: MappableBase

public protocol MappableBase : NodeConvertibleType {
    mutating func sequence(map: Map) throws -> Void
}

extension MappableBase {
    
    /// Used to convert an object back into node
    public func nodeRepresentation() throws -> Node {
        let map = Map()
        var mutable = self
        try mutable.sequence(map)
        return map.toNode
    }
}

// MARK: MappableObject

public protocol MappableObject: MappableBase {
    init(map: Map) throws
}

extension MappableObject {
    public func sequence(map: Map) throws { }
    
    public init(node: Node, context: Context = EmptyNode) throws {
        let map = Map(node: node, context: context)
        try self.init(map: map)
    }
    
    // NodeConvertibleTypeConformance
    public static func newInstance(node: Node, context: Context = EmptyNode) throws -> Self {
        guard let _ = node.objectValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        return try self.init(node: node, context: context)
    }
}

// MARK: Basic Mappable

/**
*  If you are using a simple object that can take an empty initializer
*  it should conform to this protocol.protocol
*/
public protocol BasicMappable: MappableObject {
    init() throws
}

extension BasicMappable {
    public init(map: Map) throws {
        try self.init()
        try sequence(map)
    }
}

// MARK: Inheritable Object

public class Object : MappableObject {
    required public init(map: Map) throws {}
    
    public func sequence(map: Map) throws {}
    
    public static func newInstance(node: Node, context: Context) throws -> Self {
        let map = Map(node: node, context: context)
        let new = try self.init(map: map)
        return new
    }
}
