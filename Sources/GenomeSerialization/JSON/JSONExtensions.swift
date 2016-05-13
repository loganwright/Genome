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
        return try JSONSerializer().parse(node: try toNode())
    }
    
    public func fromJSON(string: String) throws -> Self {
        return try Self.init(node: try JSONDeserializer().parse(data: string))
    }
    
}

extension NodeConvertible {
    
    public func toJSON() throws -> String? {
        return try JSONSerializer().parse(node: try toNode())
    }
    
    public func fromJSON(string: String) throws -> Self {
        return try Self.init(with: try JSONDeserializer().parse(data: string))
    }
    
}
