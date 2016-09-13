public protocol KeyAccessible {
    associatedtype Key: Hashable
    associatedtype Value
    var allItems: [(Key, Value)] { get }
    subscript(key: Key) -> Value? { get set }
    init(dictionary: [Key: Value])
}

extension Dictionary: KeyAccessible {
    public var allItems: [(Key, Value)] { return Array(self) }
    public init(dictionary: [Key: Value]) {
        self = dictionary
    }
}

// MARK: Arrays

extension Sequence where Iterator.Element: NodeRepresentable {
    public func makeNode(context: Context = EmptyNode) throws -> Node {
        let array = try map { try $0.makeNode() }
        return Node(array)
    }

    public func converted<T: NodeInitializable>(to type: [T].Type = [T].self) throws -> [T] {
        return try map { try $0.converted() }
    }
}

extension Sequence where Iterator.Element == NodeRepresentable {
    public func makeNode(context: Context = EmptyNode) throws -> Node {
        let array = try map { try $0.makeNode() }
        return Node(array)
    }

    public func converted<T: NodeInitializable>(to type: [T].Type = [T].self) throws -> [T] {
        return try map { try $0.converted() }
    }
}

extension KeyAccessible where Key == String, Value: NodeRepresentable {
    public func makeNode(context: Context = EmptyNode) throws -> Node {
        var mutable: [String : Node] = [:]
        try allItems.forEach { key, value in
            mutable[key] = try value.makeNode()
        }
        return .object(mutable)
    }

    public func converted<T: NodeInitializable>(to type: T.Type = T.self) throws -> T {
        return try makeNode().converted()
    }
}

extension KeyAccessible where Key == String, Value == NodeRepresentable {
    public func makeNode(context: Context = EmptyNode) throws -> Node {
        var mutable: [String : Node] = [:]
        try allItems.forEach { key, value in
            mutable[key] = try value.makeNode()
        }
        return .object(mutable)
    }

    public func converted<T: NodeInitializable>(to type: T.Type = T.self) throws -> T {
        return try makeNode().converted()
    }
}

// MARK: From Node

extension Array where Element: NodeInitializable {
    public init(node: NodeRepresentable, in context: Context = EmptyNode) throws {
        let node = try node.makeNode(context: context)
        let array = node.nodeArray ?? [node]
        self = try array
            .map { try Element(node: $0, in: context) }
    }

}

extension Set where Element: NodeInitializable {
    public init(node: NodeRepresentable, in context: Context = EmptyNode) throws {
        let node = try node.makeNode(context: context)
        let array = try [Element](node: node, in: context)
        self = Set(array)
    }
}

extension KeyAccessible where Key == String, Value: NodeInitializable {
    public init(node: NodeRepresentable, in context: Context = EmptyNode) throws {
        let node = try node.makeNode(context: context)
        guard let object = node.nodeObject else {
            throw NodeError.unableToConvert(node: node, expected: "\([Key: Value].self)")
        }

        var mapped: [String: Value] = [:]
        try object.forEach { key, value in
            mapped[key] = try Value(node: value, in: context)
        }
        self.init(dictionary: mapped)
    }
}

// MARK: Mappings

extension Sequence where Iterator.Element: NodeRepresentable {
    public func map<N: NodeInitializable>(to type: N.Type, in context: Context = EmptyNode) throws -> [N] {
        return try map { try N(node: $0, in: context) }
    }
}

extension Sequence where Iterator.Element == NodeRepresentable {
    public func map<N: NodeInitializable>(to type: N.Type, in context: Context = EmptyNode) throws -> [N] {
        return try map { try N(node: $0, in: context) }
    }
}

extension Sequence where Iterator.Element: Hashable {
    public var set: Set<Iterator.Element> { return Set(self) }
}
