import Foundation

extension Node {
    /**
     Attempt to initialize a node with a foundation object.
     
     - warning: will default to null if unexpected value

     - parameter any: the object to create a node from

     - throws: if fails to create node.
     */
    public init(any: Any) {
        switch any {
            // If we're coming from foundation, it will be an `NSNumber`.
            //This represents double, integer, and boolean.
        case let number as Double:
            // When coming from ObjC Any, this will represent all Integer types and boolean
            self = .number(Node.Number(number))
        // Here to catch 'Any' type, but MUST come AFTER 'Double' check for JSON fuzziness
        case let bool as Bool:
            self = .bool(bool)
        case let int as Int:
            self = .number(Number(int))
        case let uint as UInt:
            self = .number(Number(uint))
        case let string as String:
            self = .string(string)
        case let object as [String : Any]:
            self = Node(any: object)
        case let array as [Any]:
            self = .array(array.map(Node.init))
        case _ as NSNull:
            self = .null
        case let bytes as Data:
            let raw = [UInt8](bytes)
            self = .bytes(raw)
        case let bytes as NSData:
            var raw = [UInt8](repeating: 0, count: bytes.length)
            bytes.getBytes(&raw, length: bytes.length)
            self = .bytes(raw)
        default:
            self = .null
        }
    }

    /**
     Initialize a node with a foundation dictionary

     - parameter any: the dictionary to initialize with
     */
    public init(any: [String : Any]) {
        var mutable: [String : Node] = [:]
        any.forEach { key, val in
            mutable[key] = Node(any: val)
        }
        self = .object(mutable)
    }

    /**
     Initialize a node with a foundation array

     - parameter any: the array to initialize with
     */
    public init(any: [Any]) {
        let array = any.map(Node.init)
        self = .array(array)
    }

    /**
     Create an any representation of the node,
     intended for Foundation environments.
     */
    public var any: Any {
        switch self {
        case .object(let ob):
            var mapped: [String : Any] = [:]
            ob.forEach { key, val in
                mapped[key] = val.any
            }
            return mapped
        case .array(let array):
            return array.map { $0.any }
        case .bool(let bool):
            return bool
        case .number(let number):
            return number.double
        case .string(let string):
            return string
        case .null:
            return NSNull()
        case .bytes(let bytes):
            var bytes = bytes
            let data = NSData(bytes: &bytes, length: bytes.count)
            return data
        }
    }
}

extension MappableBase {
    /**
     Create a Foundation Any representation
     of the mappable object

     - throws: if mapping fails

     - returns: the foundation representation
     */
    public func foundationJSON() throws -> Any {
        return try makeNode().any
    }

    /**
     Create a foundation dictionary from the mappable object.

     - throws: if mapping fails

     - returns: the foundation representation as dictionary
     */
    public func foundationDictionary() throws -> [String : Any]? {
        return try foundationJSON() as? [String : Any]
    }

    /**
     Create a foundation array from the mappable object

     - throws: if mapping fails

     - returns: an array of type Any
     */
    public func foundationArray() throws -> [Any]? {
        return try foundationJSON() as? [Any]
    }
}
