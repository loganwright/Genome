//
//  Genome+JSON.swift
//  Genome
//
//  Created by Logan Wright on 2/11/16.
//  Copyright © 2016 lowriDevs. All rights reserved.
//

@_exported import Genome

// MARK: Convenience

extension MappableBase {
    public func makeJSON() throws -> JSON {
        let node = try makeNode()
        return try node.converted()
    }
}

extension NodeConvertible {
    public func makeJSON() throws -> JSON {
        let node = try makeNode()
        return try node.converted()
    }
}

extension Sequence where Iterator.Element: NodeConvertible {
    public func makeJSON() throws -> JSON {
        let array = try map { try $0.makeJSON() }
        return try .init(array)
    }
}

extension Dictionary where Key: CustomStringConvertible, Value: NodeConvertible {
    public func makeJSON() throws -> JSON {
        var mutable: [String : JSON] = [:]
        try self.forEach { key, value in
            mutable["\(key)"] = try value.makeJSON()
        }
        return .object(mutable)
    }
}

extension Map {
    public var json: JSON {
        // TODO: This won't actually throw, on update to JSON, remove `try!`
        return try! JSON(with: node)
    }
}
