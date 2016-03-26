//
//  BackingDataType.swift
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
public typealias BackingDataType = NodeConvertibleType

// MARK: Node

extension Node {
    public func toData<T: BackingDataType>() throws -> T {
        return try T.init(node: self)
    }
}

// MARK: Node Convertible

extension NodeConvertibleType {
    public init<T: BackingDataType>(node data: T, context: Context = EmptyNode) throws {
        let node = try data.toNode()
        try self.init(node: node, context: context)
    }
}

// MARK: Mappable Object

extension MappableObject {
    public init<T: BackingDataType>(node data: T, context: Context = EmptyNode) throws {
        self = try Self.makeWith(data, context: context)
    }
    
    private static func makeWith<T: BackingDataType>(data: T, context: Context) throws -> Self {
        let node = try data.toNode()
        guard let _ = node.objectValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        return try self.init(node: node, context: context)
    }
}
