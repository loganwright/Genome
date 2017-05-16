extension Node {
    public var nodeArray: [Node]? {
        switch self {
        case let .array(array):
            return array
        default:
            return nil
        }
    }
    
    public var nodeObject: [String: Node]? {
        switch self {
        case let .object(ob):
            return ob
        case .null:
            return [:]
        default:
            return nil
        }
    }
}
