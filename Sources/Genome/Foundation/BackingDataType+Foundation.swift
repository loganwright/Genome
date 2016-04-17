import Foundation

// MARK: Mappable Object

extension MappableObject {
    /**
     Initialize with a backing data dictionary,
     and Foundation context

     - parameter node:    backing data dictionary
     - parameter context: context

     - throws: if fails to initialize
     */
    public init<T: BackingData>(
        with node: [String : T],
        in context: [String : AnyObject] = [:]) throws {

        var mapped: [String : Node] = [:]
        try node.forEach { key, value in
            mapped[key] = try value.toNode()
        }

        let node = Node(mapped)
        try self.init(with: node, in: context)
    }
}
