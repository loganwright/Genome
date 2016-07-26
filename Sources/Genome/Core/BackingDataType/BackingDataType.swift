// MARK: Mappable Object

extension MappableObject {

    // TODO: Might not need
    public init<T: NodeRepresentable>(with data: T, in context: Context = EmptyNode) throws {
        let node = try data.makeNode()
        guard let _ = node.object else {
            throw ErrorFactory.unableToConvert(node, to: Self.self)
        }
        try self.init(with: node, in: context)
    }

    /**
     Initialize with a backing data dictionary,
     and Foundation context

     - parameter node:    backing data dictionary
     - parameter context: context

     - throws: if fails to initialize
     */
    public init<T: NodeRepresentable>(with node: [String : T], in context: Context = EmptyNode) throws {
        var mapped: [String : Node] = [:]
        try node.forEach { key, value in
            mapped[key] = try value.makeNode()
        }

        let node = Node(mapped)
        try self.init(with: node, in: context)
    }
}
