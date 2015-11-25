////
////  JsonRepresentation.swift
////  Genome
////
////  Created by Logan Wright on 6/30/15.
////  Copyright © 2015 lowriDevs. All rights reserved.
////

// MARK: To Json

public extension MappableObject {
    
    /// Used to convert an object back into json
    func jsonRepresentation() throws -> JSON {
        let map = Map()
        map.type = .ToJson
        var ob = self
        try ob.sequence(map)
        return map.toJson
    }
}

public extension Array where Element: MappableObject {
    
    /// Used to convert the array of mappable objects to an array of their json representations
    func jsonRepresentation() throws -> [JSON] {
        return try map { try $0.jsonRepresentation() }
    }
}

public extension Set where Element: MappableObject {
    
    /// Used to convert the set of mappable objects to an array of their json representations
    func jsonRepresentation() throws -> [JSON] {
        return try map { try $0.jsonRepresentation() }
    }
}
