//
//  CSVExtensions.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/12/16.
//
//

@_exported import Genome

extension MappableBase {
    
    public func toCSV() throws -> String? {
        return try CSVSerializer().parse(node: try toNode())
    }
    
    public func fromCSV(string: String) throws -> Self {
        return try Self.init(node: try CSVDeserializer().parse(data: string))
    }
    
}

extension NodeConvertible {
    
    public func toCSV() throws -> String? {
        return try CSVSerializer().parse(node: try toNode())
    }
    
    public func fromCSV(string: String) throws -> Self {
        return try Self.init(with: try CSVDeserializer().parse(data: string))
    }
    
}