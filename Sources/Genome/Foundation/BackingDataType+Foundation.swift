import Foundation

// MARK: Mappable Object

extension MappableObject {
    public init<T: BackingData>(node: [String : T], context: [String : AnyObject] = [:]) throws {
        var mapped: [String : Node] = [:]
        try node.forEach { key, value in
            mapped[key] = try value.toNode()
        }
        
        let node = Node(mapped)
        try self.init(node: node, context: context)
    }
}
