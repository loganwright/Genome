//
//  Genome.swift
//  Genome
//
//  Created by Logan Wright on 6/28/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

// MARK: MappableObject

/**
*  This is the base protocol that all objects intended to be mapped 
*  must conform to.
* 
*  SEE: Look at initializer protocols w/ the suffix Mappable.  
*  ie: `BasicMappable` for default implementations
*  
*  NOTE: You can always use this purely and declare a 
*  custom Initializer implementation
*/
public protocol MappableObject : JsonConvertibleType {
    
    /**
    This function will be called in two situations:
    
    1. after an object has been initialized and will be used to
    map the json to the properties.
    
    2. when converting the object to json
    
    Example:
    
    self.age <~> map["age"]
    
    :param: map the adaptor between the json to use when sequencing the object
    */
    mutating func sequence(map: Map) throws -> Void
    static func newInstance(map: Map) throws -> Self
}

extension MappableObject {
    public static func newInstance(json: Json, context: Json) throws -> Self {
        guard let _ = json.objectValue else {
            throw logError(JsonConvertibleError.UnableToConvert(json: json, toType: "\(self)"))
        }
        // TODO: There's some confusion here, between mappedInstance and newInstance, consider better clarification
        return try mappedInstance(json, context: context)
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
    static func newInstance(_: Map) throws -> Self {
        return try self.init()
    }
}

// MARK: Standard Mappable

/**
 *  If you're doing a non persistant or standard object that requires some 
 *  custom initialization behavior based on the map, conform to this
 *  protocol
 */
public protocol StandardMappable: MappableObject {
    init(map: Map) throws
}

public extension StandardMappable {
    public func sequence(map: Map) throws { }
    
    static func newInstance(map: Map) throws -> Self {
        return try self.init(map: map)
    }
}
