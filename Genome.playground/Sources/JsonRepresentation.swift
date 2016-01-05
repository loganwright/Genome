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
    public func jsonRepresentation() throws -> Json {
        let map = Map()
        map.type = .ToJson
        var mutable = self
        try mutable.sequence(map)
        return map.toJson
    }
}

extension CollectionType where Generator.Element: JsonConvertibleType {
    
    /// Used to convert the collections of mappable objects to an array of their json representations
    public func jsonRepresentation() throws -> Json {
        let array = try map { try $0.jsonRepresentation() }
        return .from(array)
    }
}
