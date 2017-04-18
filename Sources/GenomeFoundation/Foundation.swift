import Foundation

// MARK: Data

extension Data: NodeRepresentable {
    public func makeNode(context: Context = EmptyNode) throws -> Node {
        let js = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
        return Node(any: js)
    }
}

extension Data: NodeConvertible {
    public init(node: Node, in context: Context) throws {
        let any = node.any
        let data = try JSONSerialization.data(withJSONObject: any, options: .init(rawValue: 0))
        self = data
    }
}
