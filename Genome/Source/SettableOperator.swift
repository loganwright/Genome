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

// MARK: Settable Transform

extension Map {
    public func transform(keyType: KeyType) -> Map {
        return self[keyType]
    }
    
    public func fromNode<NodeType: NodeConvertibleType, TransformedType>(transformer: NodeType throws -> TransformedType) throws -> TransformedType {
        return try <~transformFromNode(transformer)
    }
    
    public func fromNode<NodeType: NodeConvertibleType, TransformedType>(transformer: NodeType? throws -> TransformedType) throws -> TransformedType {
        return try <~transformFromNode(transformer)
    }
}

// MARK: Extraction

extension Map {
    
    // MARK: Optional Extractions
    
    public func extract<T : NodeConvertibleType>(keyType: KeyType) throws -> T? {
        return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertibleType>(keyType: KeyType) throws -> [T]? {
        return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertibleType>(keyType: KeyType) throws -> [[T]]? {
        return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertibleType>(keyType: KeyType) throws -> [String : T]? {
        return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertibleType>(keyType: KeyType) throws -> [String : [T]]? {
        return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertibleType>(keyType: KeyType) throws -> Set<T>? {
        return try <~self[keyType]
    }
    
    // MARK: Non Optional Extractions
    
    public func extract<T : NodeConvertibleType>(keyType: KeyType) throws -> T {
        return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertibleType>(keyType: KeyType) throws -> [T] {
        return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertibleType>(keyType: KeyType) throws -> [[T]] {
        return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertibleType>(keyType: KeyType) throws -> [String : T] {
        return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertibleType>(keyType: KeyType) throws -> [String : [T]] {
        return try <~self[keyType]
    }
    
    public func extract<T : NodeConvertibleType>(keyType: KeyType) throws -> Set<T> {
        return try <~self[keyType]
    }

}

/// ****

public prefix func <~ <T: NodeConvertibleType>(map: Map) throws -> T? {
    try enforceMapType(map, expectedType: .FromNode)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as T
}

public prefix func <~ <T: NodeConvertibleType>(map: Map) throws -> [T]? {
    try enforceMapType(map, expectedType: .FromNode)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [T]
}

public prefix func <~ <T: NodeConvertibleType>(map: Map) throws -> [[T]]? {
    try enforceMapType(map, expectedType: .FromNode)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [[T]]
}

public prefix func <~ <T: NodeConvertibleType>(map: Map) throws -> [String : T]? {
    try enforceMapType(map, expectedType: .FromNode)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [String : T]
}

public prefix func <~ <T: NodeConvertibleType>(map: Map) throws -> [String : [T]]? {
    try enforceMapType(map, expectedType: .FromNode)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [String : [T]]
}

public prefix func <~ <T: NodeConvertibleType>(map: Map) throws -> Set<T>? {
    try enforceMapType(map, expectedType: .FromNode)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as Set<T>
}

// MARK: Non-Optional Casters

public prefix func <~ <T: NodeConvertibleType>(map: Map) throws -> T {
    try enforceMapType(map, expectedType: .FromNode)
    let result = try enforceResultExists(map, type: T.self)
    do {
        return try T.newInstance(result, context: map.context)
    } catch {
        let error = MappingError.UnableToMap(key: map.lastKey, error: error)
        throw logError(error)
    }
}

public prefix func <~ <T: NodeConvertibleType>(map: Map) throws -> [T] {
    try enforceMapType(map, expectedType: .FromNode)
    let result = try enforceResultExists(map, type: [T].self)
    return try [T](node: result, context: map.context)
}

public prefix func <~ <T: NodeConvertibleType>(map: Map) throws -> [[T]] {
    try enforceMapType(map, expectedType: .FromNode)
    let result = try enforceResultExists(map, type: [[T]].self)
    let array = result.arrayValue ?? [result]
    
    // TODO: Better logic?  If we just have an array, and not an array of arrays, auto convert to array of arrays here.
    let possibleArrayOfArrays = array.flatMap { $0.arrayValue }
    let isAlreadyAnArrayOfArrays = possibleArrayOfArrays.count == array.count
    let arrayOfArrays: [[Node]] = isAlreadyAnArrayOfArrays ? possibleArrayOfArrays : [array]
    return try arrayOfArrays.map { try [T](node: $0, context: map.context) }
}

public prefix func <~ <T: NodeConvertibleType>(map: Map) throws -> [String : T] {
    try enforceMapType(map, expectedType: .FromNode)
    let nodeDictionary = try expectNodeDictionaryWithMap(map, targetType: [String : T].self)
    
    var mappedDictionary: [String : T] = [:]
    for (key, value) in nodeDictionary {
        let mappedValue = try T.newInstance(value, context: map.context)
        mappedDictionary[key] = mappedValue
    }
    return mappedDictionary
}

public prefix func <~ <T: NodeConvertibleType>(map: Map) throws -> [String : [T]] {
    try enforceMapType(map, expectedType: .FromNode)
    let nodeDictionaryOfArrays = try expectNodeDictionaryOfArraysWithMap(map, targetType: [String : [T]].self)
    
    var mappedDictionaryOfArrays: [String : [T]] = [:]
    for (key, value) in nodeDictionaryOfArrays {
        let mappedValue = try [T](node: value, context: map.context)
        mappedDictionaryOfArrays[key] = mappedValue
    }
    return mappedDictionaryOfArrays
}

public prefix func <~ <T: NodeConvertibleType>(map: Map) throws -> Set<T> {
    try enforceMapType(map, expectedType: .FromNode)
    let result = try enforceResultExists(map, type: T.self)
    let nodeArray = result.arrayValue ?? [result]
    return Set<T>(try [T](node: Node.from(nodeArray), context: map.context))
}

// MARK: Transformables

public prefix func <~ <NodeInputType: NodeConvertibleType, T>(transformer: FromNodeTransformer<NodeInputType, T>) throws -> T {
    try enforceMapType(transformer.map, expectedType: .FromNode)
    return try transformer.transformValue(transformer.map.result)
}

// MARK: Enforcers

private func enforceMapType(map: Map, expectedType: Map.OperationType) throws {
    if map.type != expectedType {
        throw logError(MappingError.UnexpectedOperationType("Received mapping operation of type: \(map.type) expected: \(expectedType)"))
    }
}

private func enforceResultExists<T>(map: Map, type: T.Type) throws -> Node {
    if let result = map.result {
        return result
    } else {
        let message = "Key: \(map.lastKey) TargetType: \(T.self)"
        let error = SequenceError.FoundNil(message)
        throw logError(error)
    }
}

private func unexpectedResult<T, U>(result: Any, expected: T.Type, keyPath: KeyType, targetType: U.Type) -> ErrorType {
    let message = "Found: \(result) Expected: \(T.self) KeyPath: \(keyPath) TargetType: \(U.self)"
    let error = SequenceError.UnexpectedValue(message)
    return error
}

private func expectNodeDictionaryWithMap<T>(map: Map, targetType: T.Type) throws -> [String : Node] {
    let result = try enforceResultExists(map, type: T.self)
    if let j = result.objectValue {
        return j
    } else {
        let error = unexpectedResult(result, expected: [String : Node].self, keyPath: map.lastKey, targetType: T.self)
        throw logError(error)
    }
}

private func expectNodeDictionaryOfArraysWithMap<T>(map: Map, targetType: T.Type) throws -> [String : [Node]] {
    let result = try enforceResultExists(map, type: T.self)
    guard let object = result.objectValue else {
        let error = unexpectedResult(result, expected: [String : AnyObject].self, keyPath: map.lastKey, targetType: T.self)
        throw logError(error)
    }
    
    var mutable: [String : [Node]] = [:]
    object.forEach { key, value in
        let array = value.arrayValue ?? [value]
        mutable[key] = array
    }
    return mutable
}

// MARK: Deprecations

prefix operator <~? {}

@available(*, deprecated=1.0.9, renamed="<~")
public prefix func <~? <T: NodeConvertibleType>(map: Map) throws -> T? {
    return try <~map
}

@available(*, deprecated=1.0.9, renamed="<~")
public prefix func <~? <T: NodeConvertibleType>(map: Map) throws -> [T]? {
    return try <~map
}

@available(*, deprecated=1.0.9, renamed="<~")
public prefix func <~? <T: NodeConvertibleType>(map: Map) throws -> [[T]]? {
    return try <~map
}

@available(*, deprecated=1.0.9, renamed="<~")
public prefix func <~? <T: NodeConvertibleType>(map: Map) throws -> [String : T]? {
    return try <~map
}

@available(*, deprecated=1.0.9, renamed="<~")
public prefix func <~? <T: NodeConvertibleType>(map: Map) throws -> [String : [T]]? {
    return try <~map
}

@available(*, deprecated=1.0.9, renamed="<~")
public prefix func <~? <T: NodeConvertibleType>(map: Map) throws -> Set<T>? {
    return try <~map
}
