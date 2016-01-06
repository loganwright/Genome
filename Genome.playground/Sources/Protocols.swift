//
//  Genome.swift
//  Genome
//
//  Created by Logan Wright on 6/28/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

// MARK: MappableObject

/**
*  The base requirement for mappers
*/
public protocol MappableBase : JsonConvertibleType {
    mutating func sequence(map: Map) throws -> Void
}

public extension MappableBase {
    
    /// Used to convert an object back into json
    public func jsonRepresentation() throws -> Json {
        let map = Map()
        var mutable = self
        try mutable.sequence(map)
        return map.toJson
    }
}

// MARK: Standard Mappable

public protocol MappableObject: MappableBase {
    init(map: Map) throws
}

public extension MappableObject {
    public func sequence(map: Map) throws { }
    
    public init(js: Json, context: Json = [:]) throws {
        let map = Map(json: js, context: context)
        try self.init(map: map)
        try sequence(map)
    }
    
    // JsonConvertibleTypeConformance
    public static func newInstance(json: Json, context: Json = [:]) throws -> Self {
        guard let _ = json.objectValue else {
            throw logError(JsonConvertibleError.UnableToConvert(json: json, toType: "\(self)"))
        }
        return try self.init(js: json, context: context)
    }
}

// MARK: Basic Mappable

/**
*  If you are using a simple object that can take an empty initializer
*  it should conform to this protocol.protocol
*/
public protocol BasicMappable: MappableObject {
    init() throws
}

public extension BasicMappable {
    public init(map: Map) throws {
        try self.init()
        try sequence(map)
    }
}
