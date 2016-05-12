
// MARK: Indexable

/**
 Anything that can be used as subscript access for a Node.
 
 Int and String are supported natively, additional Indexable types
 should only be added after very careful consideration.
 */
public protocol NodeIndexable {
    /**
     Acess for 'self' within the given node, 
     ie: inverse ov `= node[self]`

     - parameter node: the node to access

     - returns: a value for index of 'self' if exists
     */
    func access(in node: Node) -> Node?

    /**
     Set given input to a given node for 'self' if possible.
     ie: inverse of `node[0] =`

     - parameter input:  value to set in parent, or `nil` if should remove
     - parameter parent: node to set input in
     */
    func set(_ input: Node?, to parent: inout Node)

    /**
     When using a path, and setting, it's possible that a value doesn't yet exist.
     We use this to have a blank object that can be set for `Self` as indexable
     type

     - returns: new node that can be modified by self as index type
     */
    static func makeIndexableNode() -> Node
}

extension NodeIndexable {
    /**
     - see: NodeIndexable
     */
    public func makeIndexableNode() -> Node {
        return self.dynamicType.makeIndexableNode()
    }
}

extension Int: NodeIndexable {
    /**
     - see: NodeIndexable
     */
    public func access(in node: Node) -> Node? {
        guard let array = node.array where self < array.count else { return nil }
        return array[self]
    }

    /**
     - see: NodeIndexable
     */
    public func set(_ input: Node?, to parent: inout Node) {
        guard let array = parent.array where self < array.count else { return }
        var mutable = array
        if let new = input {
            mutable[self] = new
        } else {
            mutable.remove(at: self)
        }
        parent = .array(mutable)
    }

    /**
     - see: NodeIndexable
     */
    public static func makeIndexableNode() -> Node {
        return .array([])
    }
}

extension String: NodeIndexable {
    /**
     - see: NodeIndexable
     */
    public func access(in node: Node) -> Node? {
        if let object = node.object?[self] {
            return object
        } else if let array = node.array {
            let value = array.flatMap(self.access)
            if value.count == array.count {
                return .array(value)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    /**
     - see: NodeIndexable
     */
    public func set(_ input: Node?, to parent: inout Node) {
        if let object = parent.object {
            var mutable = object
            mutable[self] = input
            parent = .object(mutable)
        } else if let array = parent.array {
            let mapped: [Node] = array.map { val in
                var mutable = val
                self.set(input, to: &mutable)
                return mutable
            }
            parent = .array(mapped)
        }
    }

    /**
     - see: NodeIndexable
     */
    public static func makeIndexableNode() -> Node {
        return .object([:])
    }
}
