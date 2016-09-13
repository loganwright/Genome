// MARK: MappableBase

public protocol MappableBase : NodeConvertible {
    mutating func sequence(_ map: Map) throws -> Void
}

extension MappableBase {
    /// Used to convert an object back into node
    public func makeNode(context: Context = EmptyNode) throws -> Node {
        let map = Map()
        var mutable = self
        try mutable.sequence(map)
        return map.node
    }
}

// MARK: MappableObject

public protocol MappableObject: MappableBase {
    init(map: Map) throws
}

extension MappableObject {
    public func sequence(_ map: Map) throws {
        // Empty -- here to make optional
    }

    public init(node: Node, in context: Context = EmptyNode) throws {
        let map = Map(node: node, in: context)
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

open class Object: MappableObject {
    public required init(map: Map) throws {}

    open func sequence(_ map: Map) throws {}
}

open class BasicObject: BasicMappable {
    public required init() throws {}

    open func sequence(_ map: Map) throws {}
}
