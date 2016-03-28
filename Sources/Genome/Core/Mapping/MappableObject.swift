//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: MappableBase

public protocol MappableBase : NodeConvertible {
    mutating func sequence(map: Map) throws -> Void
}

extension MappableBase {
    /// Used to convert an object back into node
    public func toNode() throws -> Node {
        let map = Map()
        var mutable = self
        try mutable.sequence(map)
        return map.node
    }
    
    init<T: BackingData>(node data: T, context: Context = EmptyNode) throws {
        let node = try data.toNode()
        self = try Self.init(node: node, context: context)
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

public class Object: MappableObject {
    required public init(map: Map) throws {}
    
    public func sequence(map: Map) throws {}
}


public class BasicObject: BasicMappable {
    required public init() throws {}
    
    public func sequence(map: Map) throws {}
}
