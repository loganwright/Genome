//
//  Genome.swift
//  Genome
//
//  Created by Logan Wright on 6/28/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

// MARK: Alias

public typealias JSON = [String : AnyObject]

/// I am using this typealias as a workaround.  It should be considered type `Map -> Self` for wherever it is required
//public typealias Initializer = Map -> MappableObject
//public typealias ThrowableInitializer = Map throws -> MappableObject
public typealias Initializer = Map throws -> MappableObject


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
public protocol MappableObject {
    
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
    
    static func initializer() -> Initializer
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
    static func initializer() -> Initializer {
        return { _ in return try self.init() }
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
    static func initializer() -> Initializer {
        return { try self.init(map: $0) }
    }
}

// MARK: Custom Mappable

/**
 *  If your object has custom behavior that requires its initialization 
 *  to be performed by a class level initializer, conform to this protocol
 */
public protocol CustomMappable : MappableObject {
    static func newInstance(map: Map) throws -> Self
}

public extension CustomMappable {
    static func initializer() -> Initializer {
        return { try newInstance($0) }
    }
}
