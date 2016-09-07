//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

extension String: Swift.Error {}

extension Dictionary {
    func mapValues<T>(_ mapper: (Value) throws -> T) rethrows -> Dictionary<Key, T> {
        var mapped: [Key: T] = [:]
        try forEach { key, value in
            mapped[key] = try mapper(value)
        }
        return mapped
    }
}

// MARK: Extraction

extension Map {

    // MARK: Transforming
    
    public func extract<T, InputType: NodeConvertible>(
        _ keyType: PathIndex...,
        transformer: @escaping (InputType) throws -> T)
        throws -> T {
            return try <~self[keyType].transformFromNode(with: transformer)
    }

    public func extract<T, InputType: NodeConvertible>(
        _ keyType: PathIndex...,
        transformer: @escaping (InputType?) throws -> T)
        throws -> T {
            return try <~self[keyType].transformFromNode(with: transformer)
    }

    // MARK: Optional Extractions
    
    public func extract<T : NodeConvertible>(
        _ keyType: PathIndex...,
        to type: T.Type = T.self)
        throws -> T? {
            return try <~self[keyType]
    }

    public func extract<T : NodeConvertible>(
        _ keyType: PathIndex...,
        to type: T.Type = T.self)
        throws -> [T]? {
            return try <~self[keyType]
    }

    public func extract<T : NodeConvertible>(
        _ keyType: PathIndex...,
        to type: T.Type = T.self)
        throws -> [[T]]? {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: PathIndex...,
        to type: T.Type = T.self)
        throws -> [String : T]? {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: PathIndex...,
        to type: T.Type = T.self)
        throws -> [String : [T]]? {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: PathIndex...,
        to type: T.Type = T.self)
        throws -> Set<T>? {
            return try <~self[keyType]
    }
    
    // MARK: Non Optional Extractions

    public func extract<T : NodeConvertible>(
        _ keyType: PathIndex...,
        to type: T.Type = T.self)
        throws -> T {
            return try <~self[keyType]
    }

    public func extract<T : NodeConvertible>(
        _ keyType: PathIndex...,
        to type: T.Type = T.self)
        throws -> [T] {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: PathIndex...,
        to type: T.Type = T.self)
        throws -> [[T]] {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: PathIndex...,
        to type: T.Type = T.self)
        throws -> [String : T] {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: PathIndex...,
        to type: T.Type = T.self)
        throws -> [String : [T]] {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: PathIndex...,
        to type: T.Type = T.self)
        throws -> Set<T> {
            return try <~self[keyType]
    }
}
