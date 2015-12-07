////
////  JsonRepresentation.swift
////  Genome
////
////  Created by Logan Wright on 6/30/15.
////  Copyright © 2015 lowriDevs. All rights reserved.
////

// MARK: To Json

extension MappableObject {
    
    /// Used to convert an object back into json
    public func jsonRepresentation() throws -> JSON {
        let map = Map()
        map.type = .ToJson
        var ob = self
        try ob.sequence(map)
        return map.toJson
    }
}

extension Array where Element: MappableObject {
    
    /// Used to convert the array of mappable objects to an array of their json representations
    public func jsonRepresentation() throws -> [JSON] {
        return try map { try $0.jsonRepresentation() }
    }
}

extension Array where Element: JSONDataType {
    
    /// Used to convert the array of mappable objects to an array of their json representations
    public func rawRepresentation() throws -> [AnyObject] {
        return try map { try $0.rawRepresentation() }
    }
}

extension Set where Element: MappableObject {
    
    /// Used to convert the set of mappable objects to an array of their json representations
    public func jsonRepresentation() throws -> [JSON] {
        return try map { try $0.jsonRepresentation() }
    }
}

extension Set where Element: JSONDataType {
    
    /// Used to convert the array of mappable objects to an array of their json representations
    public func rawRepresentation() throws -> [AnyObject] {
        return try map { try $0.rawRepresentation() }
    }
}