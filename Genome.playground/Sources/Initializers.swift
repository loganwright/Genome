//
//  Initializers.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

// MARK: MappableObject Initialization

public extension MappableObject {
    
    /**
    This is the designated mapped instance creator.  All mapped
    instance calls should funnel through here.
    
    :param: js      the json to use when mapping the object
    :param: context the context to use in the mapping
    
    :returns: an initialized instance based on the given map
    */
    static func mappedInstance(js: JSON, context: JSON = [:]) throws -> Self {
        let map = Map(json: js, context: context)
        let initialization = initializer()
        var instance = try initialization(map)
        assert(instance is Self,
            "Unfortunately, in order to support flexible subclassing, while also not enforcing a specific initializer, I need to be lenient with my type specifications in MappableObject protocol.  Otherwise, an error is thrown 'You are unable to 'use Self in a non-parameter, non-result type position`.  This means that although `Initializer` is of type `Map -> MappableObject`, it should really be considered `Map -> Self`!"
        )
        try instance.sequence(map)
        return instance as! Self
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
    static func mappedInstance(js: [JSON], context: JSON = [:]) throws -> Array {
        return try js.map { try Element.mappedInstance($0, context: context) }
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
    static func mappedInstance(js: [JSON], context: JSON = [:]) throws -> Set {
        return Set<Element>(try js.map { try Element.mappedInstance($0, context: context) })
    }
    
}
