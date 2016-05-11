//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//


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
                first.set(newValue, to: &self)
            } else {
                var next = self[first] ?? first.makeIndexableNode()
                next[keys] = newValue
                self[first] = next
            }
        }
    }
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


extension Node {
    public subscript(path path: String) -> Node? {
        get {
            let comps = path.characters.split(separator: ".").map(String.init)
            return self[comps]
        }
        set {
            let comps = path.keyPathComponents()
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
        guard
            indexes.count == 1,
            let first = indexes.first
            where first.characters.contains(".")
            else { return }

        let components = first.keyPathComponents().joined(separator: ", ")
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
        print("\tDisable this warning with flag: DISABLE_GENOME_WARNINGS")
        print("\n***************")
    }
    #endif
}

extension String {
    internal func keyPathComponents() -> [String] {
        return characters
            .split(separator: ".")
            .map(String.init)
    }
}
