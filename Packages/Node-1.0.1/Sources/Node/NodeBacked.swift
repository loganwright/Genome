public protocol NodeBacked: NodeConvertible, PathIndexable, Polymorphic {
    var node: Node { get set }
    init(_ node: Node)
}

// Convertible
extension NodeBacked {
    public init(node: Node, in context: Context) throws {
        self.init(node)
    }

    public func makeNode(context: Context = EmptyNode) -> Node {
        return node
    }
}

// Polymorphic
extension NodeBacked {
    public var isNull: Bool { return node.isNull }
    public var bool: Bool? { return node.bool }
    public var double: Double? { return node.double }
    public var int: Int? { return node.int }
    public var string: String? { return node.string }
    public var array: [Polymorphic]? {
        return node.nodeArray?.map { Self($0) }
    }
    public var object: [String: Polymorphic]? {
        return node.nodeObject.flatMap { ob in
            var result = [String: Polymorphic]()
            ob.forEach { k, v in
                result[k] = Self(v)
            }
            return result
        }
    }
}

// PathIndexable
extension NodeBacked {

    /**
     If self is an array representation, return array
     */
    public var pathIndexableArray: [Self]? {
        return node.nodeArray?.map { Self($0) }
    }

    /**
     If self is an object representation, return object
     */
    public var pathIndexableObject: [String: Self]? {
        guard let o = node.nodeObject else { return nil }
        var object: [String: Self] = [:]
        for (key, val) in o {
            object[key] = Self(val)
        }
        return object
    }

    /**
     Initialize json w/ array
     */
    public init(_ array: [Self]) {
        let array = array.map { $0.node }
        let node = Node.array(array)
        self.init(node)
    }

    /**
     Initialize json w/ object
     */
    public init(_ o: [String: Self]) {
        var object: [String: Node] = [:]
        for (key, val) in o {
            object[key] = val.node
        }
        let node = Node.object(object)
        self.init(node)
    }
}
