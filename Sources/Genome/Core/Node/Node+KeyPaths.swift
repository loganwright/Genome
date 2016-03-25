//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

extension Node {
    public mutating func gnm_setValue(val: Node, forKeyPath keyPath: String) {
        guard let object = self.objectValue else { return }
        var mutableObject = object
        
        var keys = keyPath.gnm_keypathComponents()
        guard let first = keys.first else { return }
        keys.remove(at: 0)
        
        if keys.isEmpty {
            mutableObject[first] = val
        } else {
            let rejoined = keys.joined(separator: ".")
            var subdict: Node = mutableObject[first] ?? .ObjectValue([:])
            subdict.gnm_setValue(val, forKeyPath: rejoined)
            mutableObject[first] = subdict
        }
        
        self = Node(mutableObject)
    }
    
    public func gnm_valueForKeyPath(keyPath: String) -> Node? {
        var keys = keyPath.gnm_keypathComponents()
        guard let first = keys.first else { return nil }
        guard let value = self[first] else { return nil }
        keys.remove(at: 0)
        
        guard !keys.isEmpty else { return value }
        let rejoined = keys.joined(separator: ".")
        return value.gnm_valueForKeyPath(rejoined)
    }
}

private extension String {
    func gnm_keypathComponents() -> [String] {
        return characters
            .split { $0 == "." }
            .map { String($0) }
    }
}