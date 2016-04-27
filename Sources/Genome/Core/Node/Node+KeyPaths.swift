//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//


public protocol NodeIndexable {
    func access(in node: Node) -> Node?
    func set(_ node: Node?, in parent: inout Node)

    static func makeIndexableNode() -> Node
}

extension NodeIndexable {
    public func makeIndexableNode() -> Node {
        return self.dynamicType.makeIndexableNode()
    }
}

extension Int: NodeIndexable {
    public func access(in node: Node) -> Node? {
        guard let array = node.arrayValue where self < array.count else { return nil }
        return array[self]
    }

    public func set(_ node: Node?, in parent: inout Node) {
        guard let array = parent.arrayValue where self < array.count else { return }
        var mutable = array
        if let new = node {
            mutable[self] = new
        } else {
            mutable.remove(at: self)
        }
        parent = .array(mutable)
    }

    public static func makeIndexableNode() -> Node {
        return .array([])
    }
}

extension String: NodeIndexable {
    public func access(in node: Node) -> Node? {
        if let object = node.objectValue?[self] {
            return object
        } else if let array = node.arrayValue {
            let value = array.flatMap(self.access)
            return .array(value)
        } else {
            return nil
        }
    }

    public func set(_ node: Node?, in parent: inout Node) {
        guard let object = parent.objectValue else { return }
        var mutableObject = object
        mutableObject[self] = node
        parent = Node(mutableObject)
    }

    public static func makeIndexableNode() -> Node {
        return .object([:])
    }
}

// MARK: Subscripts


extension Node {
    public subscript(indexes: NodeIndexable...) -> Node? {
        get {
            return self[indexes]
        }
        set {
            self[indexes] = newValue
        }
    }

    public subscript(indexes: [NodeIndexable]) -> Node? {
        get {
            let first = Optional(self)
            return indexes.reduce(first) { next, index in
                return next.flatMap(index.access)
            }
        }
        set {
            var keys = indexes
            guard let first = keys.first else { return }
            keys.remove(at: 0)

            if keys.isEmpty {
                first.set(newValue, in: &self)
            } else {
                var next = self[first] ?? first.makeIndexableNode()
                next[keys] = newValue
                self[first] = next
            }
        }
    }
}

extension Node {
    public subscript(path path: String) -> Node? {
        get {
            let comps = path.components(separatedBy: ".")
            return self[comps]
        }
        set {
            let comps = path.components(separatedBy: ".")
            self[comps] = newValue
        }
    }

    public subscript(indexes: String...) -> Node? {
        get {
            #if DISABLE_GENOME_WARNINGS
            #else
            warnKeypathChangeIfNecessary(indexes: indexes)
            #endif
            return self[indexes]
        }
        set {
            self[indexes] = newValue
        }
    }

    public subscript(indexes: [String]) -> Node? {
        get {
            let indexable = indexes.map { $0 as NodeIndexable }
            return self[indexable]
        }
        set {
            let indexable = indexes.map { $0 as NodeIndexable }
            self[indexable] = newValue
        }
    }

    #if DISABLE_GENOME_WARNINGS
    #else
    /**
     We have changed keypath access in a way that will silently affect older versions.
     I believe it's important to warn users

     If we find a single parameter which contains `.` notation, then in older Genome versions, this 
     would have been interpreted as a keypath. If we find indexes that match that case, we should 
     provide a warning
     
     Use
     
         node["path", "to", "object"]

     Or
     
         node[path: "path.to.object"]

     - parameter indexes: indexes to check
     */
    private func warnKeypathChangeIfNecessary(indexes: [String]) {
        guard indexes.count == 1, let first = indexes.first where first.contains(".") else {
            return
        }
        // TODO: Input Link to documentation that will stay updated
        let components = first.components(separatedBy: ".").joined(separator: ", ")
        let suggestion = "node[\(components)]"
        print("***[WARNING]***\n")
        print("\tKeypath access has changed")
        print("\tIf '\(first)' should be key path, please use:")
        print("\n\t\t\(suggestion)")
        print("\n")
        print("\tAlternatively, use:")
        print("\n\t\tnode[path: \(first)]")
        print("\n")
        print("\tIf '\(first)' should be interpreted as a key, ignore this warning")
        // TODO: Make so can disable
        print("\tDisable this warning with flag: DISABLE_GENOME_WARNINGS")
        print("\n***************")
    }
    #endif
}

extension Node {
    public subscript(indexes: Int...) -> Node? {
        get {
            return self[indexes]
        }
        set {
            self[indexes] = newValue
        }
    }

    public subscript(indexes: [Int]) -> Node? {
        get {
            let indexable = indexes.map { $0 as NodeIndexable }
            return self[indexable]
        }
        set {
            let indexable = indexes.map { $0 as NodeIndexable }
            self[indexable] = newValue
        }
    }
}
