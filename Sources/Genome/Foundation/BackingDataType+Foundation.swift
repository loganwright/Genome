import Foundation

// MARK: Mappable Object

extension MappableObject {
    public init<T: BackingDataType>(node: [String : T], context: [String : AnyObject] = [:]) throws {
        var mapped: [String : Node] = [:]
        node.forEach { key, value in
            mapped[key] = value.toNode()
        }
        
        let node = Node(mapped)
        try self.init(node: node, context: context)
    }
}
