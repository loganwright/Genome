import Foundation

// MARK: Data

extension Data: NodeRepresentable {
    public func makeNode(context: Context = EmptyNode) throws -> Node {
        let js = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
        return Node(any: js)
    }
}

extension Data: NodeInitializable {
    public init(node: Node, in context: Context) throws {
        let any = node.any
        let data = try JSONSerialization.data(withJSONObject: any, options: [])
        self = data
    }
}

// MARK: NSData

extension NSData: NodeRepresentable {
    public func makeNode(context: Context = EmptyNode) throws -> Node {
        var bytes = [UInt8](repeating: 0, count: length)
        getBytes(&bytes, length: bytes.count)
        let data = Data(bytes: bytes)
        let js = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return Node(any: js)
    }
}


#if Xcode
/*
Linux won't compile this.
*/
extension NSData: NodeInitializable {}
extension NodeInitializable where Self: NSData {
    public init(node: Node, in context: Context) throws {
        let any = node.any
        let data = try JSONSerialization.data(withJSONObject: any, options: [])
        self.init(data: data)
    }
}
#endif
