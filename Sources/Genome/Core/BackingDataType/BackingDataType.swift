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
    /**
     Map the node back to a data type

     - parameter type: the type to map to -- can be inferred

     - throws: if mapping fails

     - returns: data representation of object
     */
    public func toData<T: BackingData>(_ type: T.Type = T.self) throws -> T {
        return try type.init(with: self, in: self)
    }
}

// MARK: Node Convertible

extension NodeConvertible {

    /**
     Used to initialize a convertible from another node convertible. 
     Usually a backing data type ie: Json, yml, CSV, etc.

     - parameter data:    representation to be converted
     - parameter context: context within to init

     - throws: if mapping fails
     */
    public init<T: BackingData>(with data: T, in context: Context = EmptyNode) throws {
        let node = try data.toNode()
        try self.init(with: node, in: context)
    }
}

// MARK: Mappable Object

extension MappableObject {
    public init<T: BackingData>(with data: T, in context: Context = EmptyNode) throws {
        let node = try data.toNode()
        guard let _ = node.objectValue else {
            throw log(.UnableToConvert(node: node, to: "\(Self.self)"))
        }
        try self.init(with: node, in: context)
    }
}
