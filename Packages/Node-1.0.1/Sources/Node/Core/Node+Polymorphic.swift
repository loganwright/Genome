extension Node: Polymorphic {
    public var string: String? {
        switch self {
        case .bool(let bool):
            return "\(bool)"
        case .number(let number):
            return "\(number)"
        case .string(let string):
            return string
        default:
            return nil
        }
    }

    public var int: Int? {
        switch self {
        case .string(let string):
            return string.int
        case .number(let number):
            return number.int
        case .bool(let bool):
            return bool ? 1 : 0
        default:
            return nil
        }
    }

    public var uint: UInt? {
        switch self {
        case .string(let string):
            return string.uint
        case .number(let number):
            return number.uint
        case .bool(let bool):
            return bool ? 1 : 0
        default:
            return nil
        }
    }

    public var double: Double? {
        switch self {
        case .number(let number):
            return number.double
        case .string(let string):
            return string.double
        case .bool(let bool):
            return bool ? 1.0 : 0.0
        default:
            return nil
        }
    }

    public var isNull: Bool {
        switch self {
        case .null:
            return true
        case .string(let string):
            return string.isNull
        default:
            return false
        }
    }

    public var bool: Bool? {
        switch self {
        case .bool(let bool):
            return bool
        case .number(let number):
            return number.bool
        case .string(let string):
            return string.bool
        case .null:
            return false
        default:
            return nil
        }
    }

    public var float: Float? {
        switch self {
        case .number(let number):
            return Float(number.double)
        case .string(let string):
            return string.float
        case .bool(let bool):
            return bool ? 1.0 : 0.0
        default:
            return nil
        }
    }

    public var array: [Polymorphic]? {
        switch self {
        case .array(let array):
            return array.map { $0 }
        case .string(let string):
            return string.array
        default:
            return nil
        }
    }

    public var object: [String: Polymorphic]? {
        guard case let .object(ob) = self else { return nil }
        var object: [String: Polymorphic] = [:]

        ob.forEach { key, value in
            object[key] = value
        }

        return object
    }
}
