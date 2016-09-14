public protocol NodeConvertibleFloatingPointType: NodeConvertible {
    var doubleValue: Double { get }
    init(_ other: Double)
}

extension Float: NodeConvertibleFloatingPointType {
    public var doubleValue: Double {
        return Double(self)
    }
}

extension Double: NodeConvertibleFloatingPointType {
    public var doubleValue: Double {
        return Double(self)
    }
}

extension NodeConvertibleFloatingPointType {
    public func makeNode(context: Context = EmptyNode) -> Node {
        return .number(Node.Number(doubleValue))
    }

    public init(node: Node, in context: Context) throws {
        guard let double = node.double else {
            throw NodeError.unableToConvert(node: node, expected: "\(Self.self)")
        }
        self.init(double)
    }
}
