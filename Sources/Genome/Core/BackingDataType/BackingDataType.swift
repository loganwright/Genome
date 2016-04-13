//
//  BackingData.swift
//  Genome
//
//  Created by Logan Wright on 2/10/16.
//  Copyright © 2016 lowriDevs. All rights reserved.
//

/**
 *  This is purely a convenience name for more semantic clarity
 *
 *  Its intention is to be used as a bridge for data types such
 *  as Json, XML, Yaml, or CSV
 *
 */
public typealias BackingData = NodeConvertible

// MARK: Node

extension Node {
    public func toData<T: BackingData>(type: T.Type = T.self) throws -> T {
        return try type.init(node: self)
    }
}

// MARK: Node Convertible

extension NodeConvertible {
    public init<T: BackingData>(node data: T, context: Context = EmptyNode) throws {
        let node = try data.toNode()
        try self.init(node: node, context: context)
    }
}

// MARK: Mappable Object

extension MappableObject {
    public init<T: BackingData>(node data: T, context: Context = EmptyNode) throws {
        self = try Self.makeWith(data, context: context)
    }
    
    private static func makeWith<T: BackingData>(data: T, context: Context) throws -> Self {
        let node = try data.toNode()
        guard let _ = node.objectValue else {
            throw logError(.UnableToConvert(node: node, toType: "\(self)"))
        }
        return try self.init(node: node, context: context)
    }
}
