extension Node: PathIndexable {
    /// If self is an array representation, return array
    public var pathIndexableArray: [Node]? {
        return nodeArray
    }

    /// If self is an object representation, return object
    public var pathIndexableObject: [String: Node]? {
        return nodeObject
    }
}
