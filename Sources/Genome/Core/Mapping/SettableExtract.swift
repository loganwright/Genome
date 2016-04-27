//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: Extraction

extension Map {
    
    // MARK: Transforming
    
    public func extract<T, InputType: NodeConvertible>(
        _ keyType: NodeIndexable...,
        transformer: InputType throws -> T)
        throws -> T {
            return try <~self[keyType].transformFromNode(with: transformer)
    }

    public func extract<T, InputType: NodeConvertible>(
        _ keyType: NodeIndexable...,
        transformer: InputType? throws -> T)
        throws -> T {
            return try <~self[keyType].transformFromNode(with: transformer)
    }

    // MARK: Optional Extractions
    
    public func extract<T : NodeConvertible>(
        _ keyType: NodeIndexable...,
        to type: T.Type = T.self)
        throws -> T? {
            return try <~self[keyType]
    }

    public func extract<T : NodeConvertible>(
        _ keyType: NodeIndexable...,
        to type: T.Type = T.self)
        throws -> [T]? {
            return try <~self[keyType]
    }

    public func extract<T : NodeConvertible>(
        _ keyType: NodeIndexable...,
        to type: T.Type = T.self)
        throws -> [[T]]? {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: NodeIndexable...,
        to type: T.Type = T.self)
        throws -> [String : T]? {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: NodeIndexable...,
        to type: T.Type = T.self)
        throws -> [String : [T]]? {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: NodeIndexable...,
        to type: T.Type = T.self)
        throws -> Set<T>? {
            return try <~self[keyType]
    }
    
    // MARK: Non Optional Extractions
    
    public func extract<T : NodeConvertible>(
        _ keyType: NodeIndexable...,
        to type: T.Type = T.self)
        throws -> T {
            return try <~self[keyType]
    }

    public func extract<T : NodeConvertible>(
        _ keyType: NodeIndexable...,
        to type: T.Type = T.self)
        throws -> [T] {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: NodeIndexable...,
        to type: T.Type = T.self)
        throws -> [[T]] {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: NodeIndexable...,
        to type: T.Type = T.self)
        throws -> [String : T] {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: NodeIndexable...,
        to type: T.Type = T.self)
        throws -> [String : [T]] {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: NodeIndexable...,
        to type: T.Type = T.self)
        throws -> Set<T> {
            return try <~self[keyType]
    }
}
