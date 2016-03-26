//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: To Node

#if swift(>=3.0)
extension Collection where Iterator.Element: NodeConvertibleType {
    public func toNode() throws -> Node {
        let array = try map { try $0.toNode() }
        return Node(array)
    }
}
#else
    extension CollectionType where Generator.Element: NodeConvertibleType {
        public func toNode() throws -> Node {
            let array = try map { try $0.toNode() }
            return Node(array)
        }
    }
#endif

extension Dictionary where Key: CustomStringConvertible, Value: NodeConvertibleType {
    public func toNode() throws -> Node {
        var mutable: [String : Node] = [:]
        try self.forEach { key, value in
            mutable["\(key)"] = try value.toNode()
        }
        return .ObjectValue(mutable)
    }
}
