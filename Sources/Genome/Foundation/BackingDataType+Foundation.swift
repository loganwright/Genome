import Foundation

// MARK: Mappable Object

extension MappableObject {
    public init<T: BackingData>(
        with node: [String : T],
        in context: [String : AnyObject] = [:]) throws {

        var mapped: [String : Node] = [:]
        try node.forEach { key, value in
            mapped[key] = try value.makeNode()
        }

        let node = Node(mapped)
        try self.init(with: node, in: context)
    }
}
