//
//  Initializers.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

// MARK: MappableObject Initialization

public extension MappableObject {
    static func mappedInstance(js: Json, context: Json = [:]) throws -> Self {
        let map = Map(json: js, context: context)
        var instance = try newInstance(map)
        try instance.sequence(map)
        return instance
    }
    
    static func mappedInstance(js: [String : JsonConvertibleType], context: [String : JsonConvertibleType] = [:]) throws -> Self {
        return try mappedInstance(.from(js), context: .from(context))
    }
}

public extension Array where Element : MappableObject {
    static func mappedInstance(js: Json, context: Json = [:]) throws -> Array {
        let array = js.arrayValue ?? [js]
        return try array.map { try Element.mappedInstance($0, context: context) }
    }
}

public extension Array where Element : JsonConvertibleType {
    public static func newInstance(json: Json, context: Json = [:]) throws -> Array {
        let array = json.arrayValue ?? [json]
        return try newInstance(array, context: context)
    }
    
    public static func newInstance(json: [Json], context: Json = [:]) throws -> Array {
        return try json.map { try Element.newInstance($0, context: context) }
    }
}

public extension Set where Element : JsonConvertibleType {
    public static func newInstance(json: Json, context: Json = [:]) throws -> Set {
        let array = json.arrayValue ?? [json]
        return try newInstance(array, context: context)
    }
    
    public static func newInstance(array: [Json], context: Json = [:]) throws -> Set {
        return Set<Element>(try array.map { try Element.newInstance($0, context: context) })
    }
}
