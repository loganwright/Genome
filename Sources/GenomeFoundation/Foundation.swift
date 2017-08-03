import Foundation

// MARK: Data

extension Data: NodeRepresentable {
    public func makeNode(in context: Context? = GenomeContext.default) throws -> Node {
        let js = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
        return Node(any: js)
    }
}

extension Data: NodeInitializable {
    public init(node: Node) throws {
        let any = node.any
        let data = try JSONSerialization.data(withJSONObject: any, options: .init(rawValue: 0))
        self = data
    }
}
