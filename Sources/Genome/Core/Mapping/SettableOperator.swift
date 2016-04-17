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
        _ keyType: Key,
        transformer: InputType throws -> T)
        throws -> T {
            return try <~self[keyType].transformFromNode(with: transformer)
    }
    
    public func extract<T, InputType: NodeConvertible>(
        _ keyType: Key,
        transformer: InputType? throws -> T)
        throws -> T {
            return try <~self[keyType].transformFromNode(with: transformer)
    }

    // MARK: Optional Extractions
    
    public func extract<T : NodeConvertible>(
        _ keyType: Key,
        to type: T.Type = T.self)
        throws -> T? {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: Key,
        to type: T.Type = T.self)
        throws -> [T]? {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: Key,
        to type: T.Type = T.self)
        throws -> [[T]]? {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: Key,
        to type: T.Type = T.self)
        throws -> [String : T]? {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: Key,
        to type: T.Type = T.self)
        throws -> [String : [T]]? {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: Key,
        to type: T.Type = T.self)
        throws -> Set<T>? {
            return try <~self[keyType]
    }
    
    // MARK: Non Optional Extractions
    
    public func extract<T : NodeConvertible>(
        _ keyType: Key,
        to type: T.Type = T.self)
        throws -> T {
            return try <~self[keyType]
    }

    public func extract<T : NodeConvertible>(
        _ keyType: Key,
        to type: T.Type = T.self)
        throws -> [T] {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: Key,
        to type: T.Type = T.self)
        throws -> [[T]] {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: Key,
        to type: T.Type = T.self)
        throws -> [String : T] {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: Key,
        to type: T.Type = T.self)
        throws -> [String : [T]] {
            return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertible>(
        _ keyType: Key,
        to type: T.Type = T.self)
        throws -> Set<T> {
            return try <~self[keyType]
    }
}

/// ****

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> T? {
    try map.enforceFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as T
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [T]? {
    try map.enforceFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [T]
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [[T]]? {
    try map.enforceFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [[T]]
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [String : T]? {
    try map.enforceFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [String : T]
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [String : [T]]? {
    try map.enforceFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [String : [T]]
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> Set<T>? {
    try map.enforceFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as Set<T>
}

// MARK: Non-Optional Casters

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> T {
    let result = try map.enforceResult(targeting: T.self)
    return try T.init(with: result, in: map.context)
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [T] {
    let result = try map.enforceResult(targeting: [T].self)
    return try [T].init(with: result, in: map.context)
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> Set<T> {
    let result = try map.enforceResult(targeting: T.self)
    let mapped = try [T].init(with: result, in: map.context)
    return Set<T>(mapped)
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [[T]] {
    let result = try map.enforceResult(targeting: [[T]].self)
    let array = result.arrayOfArrays
    return try array.map { try [T].init(with: $0, in: map.context) }
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [String : T] {
    let nodeDictionary = try map.expectNodeDictionary(targeting: [String : T].self)
    
    var mapped: [String : T] = [:]
    for (key, value) in nodeDictionary {
        let mappedValue = try T.init(with: value, in: map.context)
        mapped[key] = mappedValue
    }
    return mapped
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [String : [T]] {
    let nodeDictionaryOfArrays = try map.expectNodeDictionary(targeting: [String : [T]].self)

    var mappedDictionaryOfArrays: [String : [T]] = [:]
    for (key, value) in nodeDictionaryOfArrays {
        let mappedValue = try [T].init(with: value, in: map.context)
        mappedDictionaryOfArrays[key] = mappedValue
    }
    return mappedDictionaryOfArrays
}

// MARK: Transformables

public prefix func <~ <NodeInputType: NodeConvertible, T>(transformer: FromNodeTransformer<NodeInputType, T>) throws -> T {
    try transformer.map.enforceFromNode()
    return try transformer.transform(transformer.map.result)
}

// MARK: Enforcers

extension Map {
    private func enforceFromNode() throws {
        try enforceOperationType(expecting: .FromNode)
    }

    private func enforceOperationType(expecting: OperationType) throws {
        if type != expecting {
            throw log(.UnexpectedOperationType(got: type, expected: expecting))
        }
    }

    private func enforceResult<T>(targeting: T.Type) throws -> Node {
        try enforceFromNode()
        if let result = self.result {
            return result
        } else {
            let error = Error.foundNil(for: lastKey, expected: "\(T.self)")
            throw log(error)
        }
    }

}

extension Map {
    private func expectNodeDictionary<T>(targeting: T.Type) throws -> [String : Node] {
        let result = try enforceResult(targeting: T.self)
        if let j = result.objectValue {
            return j
        } else {
            let error = Error.unexpectedValue(got: result,
                                              expected: [String : Node].self,
                                              for: lastKey,
                                              target: T.self)
            throw log(error)
        }
    }
}

extension Node {
    var arrayOfArrays: [[Node]] {
        let array = arrayValue ?? [self]
        // TODO: Better logic?  If we just have an array, and not an array of arrays, auto convert to array of arrays here.
        let possibleArrayOfArrays = array.flatMap { $0.arrayValue }
        let isAlreadyAnArrayOfArrays = possibleArrayOfArrays.count == array.count
        let arrayOfArrays: [[Node]] = isAlreadyAnArrayOfArrays ? possibleArrayOfArrays : [array]
        return arrayOfArrays
    }
}
