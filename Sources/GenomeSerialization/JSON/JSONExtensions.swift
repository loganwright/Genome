//
//  JSONExtensions.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/12/16.
//
//

@_exported import Genome

extension MappableBase {
    
    public func toJSON() throws -> String? {
        return try JSONSerializer(node: try toNode()).parse()
    }
    
    public func fromJSON(string: String) throws -> Self {
        return try Self.init(node: try JSONDeserializer(data: string).parse())
    }
    
}

extension NodeConvertible {
    
    public func toJSON() throws -> String? {
        return try JSONSerializer(node: try toNode()).parse()
    }
    
    public func fromJSON(string: String) throws -> Self {
        return try Self.init(with: try JSONDeserializer(data: string).parse())
    }
    
}
