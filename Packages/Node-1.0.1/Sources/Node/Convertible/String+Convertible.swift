extension String: NodeConvertible {
    public func makeNode(context: Context = EmptyNode) -> Node {
        return .string(self)
    }

    public init(node: Node, in context: Context) throws {
        guard let string = node.string else {
            throw NodeError.unableToConvert(node: node, expected: "\(String.self)")
        }
        self = string
    }
}
