/**
    Node is meant to be a transitive data structure that can be used to facilitate conversions
    between different types.
*/
public enum Node {
    case null
    case bool(Bool)
    case number(Number)
    case string(String)
    case array([Node])
    case object([String: Node])
    case bytes([UInt8])
}
