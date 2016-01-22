//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: To Node

extension CollectionType where Generator.Element: NodeConvertibleType {
    public func nodeRepresentation() throws -> Node {
        let array = try map { try $0.nodeRepresentation() }
        return .from(array)
    }
}

extension Dictionary where Key: CustomStringConvertible, Value: NodeConvertibleType {
    public func nodeRepresentation() throws -> Node {
        var mutable: [String : Node] = [:]
        try self.forEach { key, value in
            mutable["\(key)"] = try value.nodeRepresentation()
        }
        return .ObjectValue(mutable)
    }
}
