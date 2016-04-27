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
    mutating func sequence(_ map: Map) throws -> Void
}

extension MappableBase {
    /// Used to convert an object back into node
    public func toNode() throws -> Node {
        let map = Map()
        var mutable = self
        try mutable.sequence(map)
        return map.node
    }
    
    public init<T: BackingData>(node data: T, in context: Context = EmptyNode) throws {
        let node = try data.toNode()
        self = try Self.init(with: node, in: context)
    }
}

extension MappableBase {
    public func toData<T: BackingData>(type: T.Type = T.self) throws -> T {
        let node = try toNode()
        return try node.toData()
    }
}

// MARK: MappableObject

public protocol MappableObject: MappableBase {
    init(with map: Map) throws
}

extension MappableObject {
    public func sequence(_ map: Map) throws {
        // Empty
    }

    public init(with node: Node, in context: Context = EmptyNode) throws {
        let map = Map(with: node, in: context)
        try self.init(with: map)
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
    public init(with map: Map) throws {
        try self.init()
        try sequence(map)
    }
}

// MARK: Inheritable Object

public class Object: MappableObject {
    required public init(with map: Map) throws {}
    
    public func sequence(_ map: Map) throws {}
}


public class BasicObject: BasicMappable {
    required public init() throws {}
    
    public func sequence(_ map: Map) throws {}
}
