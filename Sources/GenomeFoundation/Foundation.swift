import Foundation

extension NSData: NodeRepresentable {
    public func makeNode(context: Context = EmptyNode) throws -> Node {
        let js = try JSONSerialization.jsonObject(with: self as Data, options: .allowFragments)
        return Node(any: js)
    }
}

extension Data: NodeRepresentable {
    public func makeNode(context: Context = EmptyNode) throws -> Node {
        let js = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
        return Node(any: js)
    }
}

extension NSData: NodeConvertible {}

extension NodeInitializable where Self: NSData {
    public init(node: Node, in context: Context) throws {
        let any = node.any
        let data = try JSONSerialization.data(withJSONObject: any, options: .init(rawValue: 0))
        self = .init(data: data)
    }
}

extension Data: NodeConvertible {
    public init(node: Node, in context: Context) throws {
        let any = node.any
        let data = try JSONSerialization.data(withJSONObject: any, options: .init(rawValue: 0))
        self = data
    }
}
