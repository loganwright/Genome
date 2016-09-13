/**
    This protocol provides syntax for 
    easily accessing values from generic data. 
*/
public protocol Polymorphic {
    // Required
    var isNull: Bool { get }
    var bool: Bool? { get }
    var double: Double? { get }
    var int: Int? { get }
    var string: String? { get }
    var array: [Polymorphic]? { get }
    var object: [String : Polymorphic]? { get }

    // Optional
    var float: Float? { get }
    var uint: UInt? { get }
}

extension Polymorphic {
    public var float: Float? {
        guard let double = double else {
            return nil
        }

        return Float(double)
    }

    public var uint: UInt? {
        guard let i = int else { return nil }
        guard i >= 0 else { return nil }
        return UInt(i)
    }
}
