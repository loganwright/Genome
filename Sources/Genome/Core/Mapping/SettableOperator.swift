//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: Casting

prefix operator <~ {}

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

// MARK: Settable Operators

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> T? {
    try map.enforceFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try execute(with: map,
                       body: <~map as T)
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [T]? {
    try map.enforceFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try execute(with: map,
                       body: <~map as [T])
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [[T]]? {
    try map.enforceFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try execute(with: map,
                       body: <~map as [[T]])
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [String : T]? {
    try map.enforceFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try execute(with: map,
                       body: <~map as [String : T])
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [String : [T]]? {
    try map.enforceFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try execute(with: map,
                       body: <~map as [String : [T]])
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> Set<T>? {
    try map.enforceFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try execute(with: map,
                       body: <~map as Set<T>)
}

// MARK: Non-Optional Casters

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> T {
    let result = try map.enforceResult(targeting: T.self)
    return try execute(with: map,
                       body: T.init(with: result, in: map.context))
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [T] {
    let result = try map.enforceResult(targeting: [T].self)
    return try execute(with: map,
                       body: [T].init(with: result, in: map.context))
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> Set<T> {
    let result = try map.enforceResult(targeting: T.self)
    let mapped = try execute(with: map,
                             body: [T].init(with: result, in: map.context))
    return Set<T>(mapped)
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [[T]] {
    let result = try map.enforceResult(targeting: [[T]].self)
    let array = result.arrayOfArrays
    return try execute(with: map,
                       body: array.map { try [T].init(with: $0, in: map.context) })
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [String : T] {
    let nodeDictionary = try execute(with: map,
                                     body: map.expectNodeDictionary(targeting: [String : T].self))
    
    var mapped: [String : T] = [:]
    for (key, value) in nodeDictionary {
        mapped[key] = try execute(with: map,
                                  body: T.init(with: value, in: map.context))
    }
    return mapped
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [String : [T]] {
    let type = [String : [T]].self
    let nodeDictionaryOfArrays = try execute(with: map,
                                             body: map.expectNodeDictionary(targeting: type))

    var mapped: [String : [T]] = [:]
    for (key, value) in nodeDictionaryOfArrays {
        mapped[key] = try execute(with: map,
                                  body: [T].init(with: value, in: map.context))
    }
    return mapped
}

// MARK: Transformables

public prefix func <~ <NodeInputType: NodeConvertible, T>(transformer: FromNodeTransformer<NodeInputType, T>) throws -> T {
    try transformer.map.enforceFromNode()
    return try execute(with: transformer.map,
                       body: transformer.transform(transformer.map.result))
}

// MARK: Error Metadata

/**
 Used to wrap failable operations so that a given key path can be specified in error

 - parameter map:  map being used in operation
 - parameter body: the failable function to append metadata to

 - throws: an error if body fails

 - returns: the underlying value if possible
 */
private func execute<T>(with map: Map, body: @autoclosure Void throws -> T) throws -> T {
    do {
        return try body()
    } catch let e as Error {
        throw e.appendLastKeyPath(map.lastKey)
    } catch {
        throw error
    }
}

// MARK: Enforcers

extension Map {
    private func enforceFromNode() throws {
        try type.assert(equals: .fromNode)
    }

    private func enforceResult<T>(targeting: T.Type) throws -> Node {
        try enforceFromNode()
        if let result = self.result {
            return result
        } else {
            throw ErrorFactory.foundNil(for: lastKey,
                                        expected: T.self)
        }
    }
}

extension Map {
    private func expectNodeDictionary<T>(targeting: T.Type) throws -> [String : Node] {
        let result = try enforceResult(targeting: T.self)
        if let j = result.objectValue {
            return j
        } else {
            throw ErrorFactory.unableToConvert(result, to: T.self)
        }
    }
}

extension Node {
    private var arrayOfArrays: [[Node]] {
        let array = arrayValue ?? [self]
        // TODO: Better logic?  If we just have an array, and not an array of arrays, auto convert to array of arrays here.
        let possibleArrayOfArrays = array.flatMap { $0.arrayValue }
        let isAlreadyAnArrayOfArrays = possibleArrayOfArrays.count == array.count
        let arrayOfArrays: [[Node]] = isAlreadyAnArrayOfArrays ? possibleArrayOfArrays : [array]
        return arrayOfArrays
    }
}
