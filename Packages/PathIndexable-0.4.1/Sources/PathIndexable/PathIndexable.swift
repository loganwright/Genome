
/**
 Objects wishing to inherit complex subscripting should implement
 this protocol
 */
public protocol PathIndexable {
    /// If self is an array representation, return array
    var pathIndexableArray: [Self]? { get }

    /// If self is an object representation, return object
    var pathIndexableObject: [String: Self]? { get }

    /**
     Initialize a new object encapsulating an array of Self

     - parameter array: value to encapsulate
     */
    init(_ array: [Self])

    /**
     Initialize a new object encapsulating an object of type [String: Self]

     - parameter object: value to encapsulate
     */
    init(_ object: [String: Self])
}

// MARK: Indexable

/**
 Anything that can be used as subscript access for a Node.
 
 Int and String are supported natively, additional Indexable types
 should only be added after very careful consideration.
 */
public protocol PathIndex {
    /**
        Acess for 'self' within the given node,
        ie: inverse ov `= node[self]`

        - parameter node: the node to access

        - returns: a value for index of 'self' if exists
    */
    func access<T: PathIndexable>(in node: T) -> T?

    /**
        Set given input to a given node for 'self' if possible.
        ie: inverse of `node[0] =`

        - parameter input:  value to set in parent, or `nil` if should remove
        - parameter parent: node to set input in
    */
    func set<T: PathIndexable>(_ input: T?, to parent: inout T)

    /**
         Create an empty structure that can be set with the given type.
         
         ie: 
         - a string will create an empty dictionary to add itself as a value
         - an Int will create an empty array to add itself as a value

         - returns: an empty structure that can be set by Self
    */
    func makeEmptyStructure<T: PathIndexable>() -> T
}

extension Int: PathIndex {
    /**
        - see: PathIndex
    */
    public func access<T: PathIndexable>(in node: T) -> T? {
        guard
            let array = node.pathIndexableArray,
            self < array.count
        else {
            return nil
        }

        return array[self]
    }

    /**
        - see: PathIndex
    */
    public func set<T: PathIndexable>(_ input: T?, to parent: inout T) {
        guard
            let array = parent.pathIndexableArray,
            self < array.count
        else {
            return
        }
        
        var mutable = array
        if let new = input {
            mutable[self] = new
        } else {
            mutable.remove(at: self)
        }
        parent = type(of: parent).init(mutable)
    }

    public func makeEmptyStructure<T: PathIndexable>() -> T {
        return T([])
    }
}

extension String: PathIndex {
    /**
        - see: PathIndex
    */
    public func access<T: PathIndexable>(in node: T) -> T? {
        if let object = node.pathIndexableObject?[self] {
            return object
        } else if let array = node.pathIndexableArray {
            // Index takes precedence
            if let idx = Int(self), idx < array.count {
                return array[idx]
            }

            let value = array.flatMap(self.access)
            if value.count > 0 {
                return type(of: node).init(value)
            }

            return nil
        }

        return nil
    }

    /**
        - see: PathIndex
    */
    public func set<T: PathIndexable>(_ input: T?, to parent: inout T) {
        if let object = parent.pathIndexableObject {
            var mutable = object
            mutable[self] = input
            parent = type(of: parent).init(mutable)
        } else if let array = parent.pathIndexableArray {
            let mapped: [T] = array.map { val in
                var mutable = val
                self.set(input, to: &mutable)
                return mutable
            }
            parent = type(of: parent).init(mapped)
        }
    }


    public func makeEmptyStructure<T: PathIndexable>() -> T {
        return T([:])
    }
}
