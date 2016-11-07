extension UInt: NodeConvertible {}
extension UInt8: NodeConvertible {}
extension UInt16: NodeConvertible {}
extension UInt32: NodeConvertible {}
extension UInt64: NodeConvertible {}

extension UnsignedInteger {
    public func makeNode(context: Context = EmptyNode) -> Node {
        let number = Node.Number(self.toUIntMax())
        return .number(number)
    }

    public init(node: Node, in context: Context) throws {
        guard let int = node.uint else {
            throw NodeError.unableToConvert(node: node, expected: "\(Self.self)")
        }

        self.init(int.toUIntMax())
    }
}
