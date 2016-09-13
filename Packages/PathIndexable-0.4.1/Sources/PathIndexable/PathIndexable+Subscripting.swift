//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: Subscripts

extension PathIndexable {
    public subscript(indexes: PathIndex...) -> Self? {
        get {
            return self[indexes]
        }
        set {
            self[indexes] = newValue
        }
    }

    public subscript(indexes: [PathIndex]) -> Self? {
        get {
            let first: Optional<Self> = self
            return indexes.reduce(first) { next, index in
                guard let next = next else { return nil }
                return index.access(in: next)
            }
        }
        set {
            var keys = indexes
            guard let first = keys.first else { return }
            keys.remove(at: 0)

            if keys.isEmpty {
                first.set(newValue, to: &self)
            } else {
                var next = self[first] ?? first.makeEmptyStructure() as Self
                next[keys] = newValue
                self[first] = next
            }
        }
    }
}

extension PathIndexable {
    public subscript(indexes: Int...) -> Self? {
        get {
            return self[indexes]
        }
        set {
            self[indexes] = newValue
        }
    }

    public subscript(indexes: [Int]) -> Self? {
        get {
            let indexable = indexes.map { $0 as PathIndex }
            return self[indexable]
        }
        set {
            let indexable = indexes.map { $0 as PathIndex }
            self[indexable] = newValue
        }
    }
}

extension PathIndexable {
    public subscript(path path: String) -> Self? {
        get {
            let comps = path.characters.split(separator: ".").map(String.init)
            return self[comps]
        }
        set {
            let comps = path.keyPathComponents()
            self[comps] = newValue
        }
    }

    public subscript(indexes: String...) -> Self? {
        get {
            return self[indexes]
        }
        set {
            self[indexes] = newValue
        }
    }

    public subscript(indexes: [String]) -> Self? {
        get {
            let indexable = indexes.map { $0 as PathIndex }
            return self[indexable]
        }
        set {
            let indexable = indexes.map { $0 as PathIndex }
            self[indexable] = newValue
        }
    }

}

extension String {
    internal func keyPathComponents() -> [String] {
        return characters
            .split(separator: ".")
            .map(String.init)
    }
}
