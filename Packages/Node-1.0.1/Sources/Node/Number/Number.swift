extension Node {
    public enum Number {
        case int(Int)
        case uint(UInt)
        case double(Double)
    }
}

// MARK: Initializers

extension Node.Number {
    public init<I: Integer>(_ value: I) {
        let max = value.toIntMax()
        let int = Int(max)
        self = .int(int)
    }

    public init<U: UnsignedInteger>(_ value: U) {
        let max = value.toUIntMax()
        let uint = UInt(max)
        self = .uint(uint)
    }

    public init(_ value: Float) {
        let double = Double(value)
        self = .init(double)
    }

    public init(_ value: Double) {
        self = .double(value)
    }
}

// MARK: Accessors

extension UInt {
    static var intMax = UInt(Int.max)
}

extension Node.Number {
    public var int: Int {
        switch self {
        case let .int(i):
            return i
        case let .uint(u):
            guard u < UInt.intMax else { return Int.max }
            return Int(u)
        case let .double(d):
            return Int(d)
        }
    }

    public var uint: UInt {
        switch self {
        case let .int(i):
            guard i > 0 else { return 0 }
            return UInt(i)
        case let .uint(u):
            return u
        case let .double(d):
            return UInt(d)
        }
    }

    public var double: Double {
        switch self {
        case let .int(i):
            return Double(i)
        case let .uint(u):
            return Double(u)
        case let .double(d):
            return Double(d)
        }
    }
}

extension Node.Number {
    public var bool: Bool? {
        switch self {
        case let .int(i):
            switch i {
            case 1: return true
            case 0: return false
            default:
                return nil
            }
        case let .uint(u):
            switch u {
            case 1: return true
            case 0: return false
            default:
                return nil
            }
        case let .double(d):
            switch d {
            case 1.0: return true
            case 0.0: return false
            default:
                return nil
            }
        }
    }
}

// MARK: Equatable

extension Node.Number: Equatable {}

public func ==(lhs: Node.Number, rhs: Node.Number) -> Bool {
    switch (lhs, rhs) {
    case let (.int(l), .int(r)):
        return l == r
    case let (.int(l), .uint(r)):
        guard l >= 0 && r <= UInt(Int.max) else { return false }
        return l == Int(r)
    case let (.int(l), .double(r)):
        guard r.truncatingRemainder(dividingBy: 1) == 0.0 else { return false }
        return l == Int(r)
    case let (.uint(l), .int(r)):
        guard l <= UInt(Int.max) && r >= 0 else { return false }
        return Int(l) == r
    case let (.uint(l), .uint(r)):
        return l == r
    case let (.uint(l), .double(r)):
        guard r >= 0 && r.truncatingRemainder(dividingBy: 1) == 0.0 else { return false }
        return l == UInt(r)
    case let (.double(l), .int(r)):
        guard l.truncatingRemainder(dividingBy: 1) == 0.0 else { return false }
        return Int(l) == r
    case let (.double(l), .uint(r)):
        guard l.truncatingRemainder(dividingBy: 1) == 0.0 else { return false }
        return UInt(l) == r
    case let (.double(l), .double(r)):
        return l == r
    }
}

// MARK: Literals

extension Node.Number: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

extension Node.Number: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
}

// MARK: String

extension Node.Number: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .int(i):
            return i.description
        case let .uint(u):
            return u.description
        case let .double(d):
            return d.description
        }
    }
}
