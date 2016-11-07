extension Int: NodeConvertible {}
extension Int8: NodeConvertible {}
extension Int16: NodeConvertible {}
extension Int32: NodeConvertible {}
extension Int64: NodeConvertible {}

extension SignedInteger {
    public func makeNode(context: Context = EmptyNode) -> Node {
        let number = Node.Number(self.toIntMax())
        return .number(number)
    }

    public init(node: Node, in context: Context) throws {
        guard let int = node.int else {
            throw NodeError.unableToConvert(node: node, expected: "\(Self.self)")
        }

        self.init(int.toIntMax())
    }
}
