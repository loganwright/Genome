extension Node: Equatable {}

public func ==(lhs: Node, rhs: Node) -> Bool {
    switch (lhs, rhs) {
    case (.null, .null):
        return true
    case let (.bool(l), .bool(r)):
        return l == r
    case let (.number(l), .number(r)):
        return l == r
    case let (.string(l), .string(r)):
        return l == r
    case let (.array(l), .array(r)):
        return l == r
    case let (.object(l), .object(r)):
        return l == r
    case let (.bytes(l), .bytes(r)):
        return l == r
    default:
        return false
    }
}
