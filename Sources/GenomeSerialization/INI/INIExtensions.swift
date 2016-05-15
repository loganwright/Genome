//
//  INIExtensions.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/13/16.
//
//

@_exported import Genome

extension MappableBase {
    
    public func toINI() throws -> String? {
        return try INISerializer().parse(node: try toNode())
    }
    
    public func fromINI(string: String) throws -> Self {
        return try Self.init(node: try INIDeserializer().parse(data: string))
    }
    
}

extension NodeConvertible {
    
    public func toINI() throws -> String? {
        return try INISerializer().parse(node: try toNode())
    }
    
    public func fromINI(string: String) throws -> Self {
        return try Self.init(with: try INIDeserializer().parse(data: string))
    }
    
}
