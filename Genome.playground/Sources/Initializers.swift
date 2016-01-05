//
//  Initializers.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

// MARK: MappableObject Initialization

extension Json : JsonConvertibleType {
    public static func newInstance(json: Json, context: Json) -> Json {
        return json
    }
    
    public func jsonRepresentation() -> Json {
        return self
    }
}

extension Dictionary where Key: CustomStringConvertible, Value: JsonConvertibleType {
    func jsonRepresentation() throws -> Json {
        var mutableObject: [String : Json] = [:]
        try self.forEach { key, value in
            mutableObject[key.description] = try value.jsonRepresentation()
        }
        return .ObjectValue(mutableObject)
    }
}

// TODO: Move to Foundation Specific
// TODO: Make other direction

extension Json {
    public static func from(dictionary: [String : JsonConvertibleType]) throws -> Json {
        var mutable: [String : Json] = [:]
        try dictionary.forEach { key, value in
            mutable[key] = try value.jsonRepresentation()
        }
        
        return .from(mutable)
    }
}

public extension MappableObject {
    
    /**
    This is the designated mapped instance creator.  All mapped
    instance calls should funnel through here.
    
    :param: js      the json to use when mapping the object
    :param: context the context to use in the mapping
    
    :returns: an initialized instance based on the given map
    */
    static func mappedInstance(js: Json, context: Json = .ObjectValue([:])) throws -> Self {
        let map = Map(json: js, context: context)
        var instance = try newInstance(map)
        try instance.sequence(map)
        return instance
    }
    
    static func mappedInstance(js: [String : JsonConvertibleType], context: [String : JsonConvertibleType] = [:]) throws -> Self {
        let map = Map(json: try .from(js), context: try .from(context))
        var instance = try newInstance(map)
        try instance.sequence(map)
        return instance
    }
}

public extension Array where Element : MappableObject {
    /**
    Use this method to initialize an array of objects from a json array
    
    :example: let foods = [Food].mappedInstance(jsonArray)
    
    :param: js      the array of json
    :param: context the context to use when mapping the individual objects
    
    :returns: an array of objects initialized from the json array in the provided context
    */
    static func mappedInstance(js: Json, context: Json = .ObjectValue([:])) throws -> Array {
        let array = js.arrayValue ?? [js]
        return try array.map { try Element.mappedInstance($0, context: context) }
    }
}

public extension Array where Element : JsonConvertibleType {
    // TODO: Should this take only `[Json]` for clarity? instead?
    public static func newInstance(json: Json, context: Json = .ObjectValue([:])) throws -> Array {
        let array = json.arrayValue ?? [json]
        return try newInstance(array, context: context)
    }
    
    public static func newInstance(json: [Json], context: Json = .ObjectValue([:])) throws -> Array {
        return try json.map { try Element.newInstance($0, context: context) }
    }
}

public extension Set where Element : MappableObject {
    /**
     Use this method to initialize a set of objects from a json array
     
     :example: let foods = Set<Food>.mappedInstance(jsonArray)
     
     :param: js      the array of json
     :param: context the context to use when mapping the individual objects
     
     :returns: a set of objects initialized from the json array in the provided context
     */
    
    public static func newInstance(json: Json, context: Json) throws -> Set {
        guard let array = json.arrayValue else {
            throw logError(Lazy.Error("Not an array ..."))
        }
        return Set<Element>(try array.map { try Element.newInstance($0, context: context) })
    }
}
