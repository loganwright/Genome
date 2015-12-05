
// MARK: Casting

prefix operator <~ {}
prefix operator <~? {}

// MARK: Optional Casters

public prefix func <~? <T>(map: Map) throws -> T? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as T
}

public prefix func <~? <T: MappableObject>(map: Map) throws -> T? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as T
}

public prefix func <~? <T: MappableObject>(map: Map) throws -> [T]? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [T]
}

public prefix func <~? <T: MappableObject>(map: Map) throws -> [[T]]? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [[T]]
}

public prefix func <~? <T: MappableObject>(map: Map) throws -> [String : T]? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [String : T]
}

public prefix func <~? <T: MappableObject>(map: Map) throws -> [String : [T]]? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [String : [T]]
}

public prefix func <~? <T: MappableObject>(map: Map) throws -> Set<T>? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as Set<T>
}

// MARK: Non-Optional Casters

public prefix func <~ <T>(map: Map) throws -> T {
    try enforceMapType(map, expectedType: .FromJson)
    let result = try enforceResultExists(map, type: T.self)
    
    if let value = result as? T {
        return value
    } else {
        let error = unexpectedResult(result, expected: T.self, keyPath: map.lastKey, targetType: T.self)
        throw logError(error)
    }
}

public prefix func <~ <T: MappableObject>(map: Map) throws -> T {
    try enforceMapType(map, expectedType: .FromJson)
    let result = try enforceResultExists(map, type: T.self)
    
    if let json = result as? JSON {
        return try T.mappedInstance(json, context: map.context)
    } else {
        let error = unexpectedResult(result, expected: JSON.self, keyPath: map.lastKey, targetType: T.self)
        throw logError(error)
    }
}

public prefix func <~ <T: MappableObject>(map: Map) throws -> [T] {
    try enforceMapType(map, expectedType: .FromJson)
    let jsonArray = try expectJsonArrayWithMap(map, targetType: [T].self)
    return try [T].mappedInstance(jsonArray, context: map.context)
}

public prefix func <~ <T: MappableObject>(map: Map) throws -> [[T]] {
    try enforceMapType(map, expectedType: .FromJson)
    let jsonArrayOfArrays = try expectJsonArrayOfArraysWithMap(map, targetType: [[T]].self)
    return try jsonArrayOfArrays.map { try [T].mappedInstance($0, context: map.context) }
}

public prefix func <~ <T: MappableObject>(map: Map) throws -> [String : T] {
    try enforceMapType(map, expectedType: .FromJson)
    let jsonDictionary = try expectJsonDictionaryWithMap(map, targetType: [String : T].self)
    
    var mappedDictionary: [String : T] = [:]
    for (key, value) in jsonDictionary {
        let mappedValue = try T.mappedInstance(value, context: map.context)
        mappedDictionary[key] = mappedValue
    }
    return mappedDictionary
}

public prefix func <~ <T: MappableObject>(map: Map) throws -> [String : [T]] {
    try enforceMapType(map, expectedType: .FromJson)
    let jsonDictionaryOfArrays = try expectJsonDictionaryOfArraysWithMap(map, targetType: [String : [T]].self)
    
    var mappedDictionaryOfArrays: [String : [T]] = [:]
    for (key, value) in jsonDictionaryOfArrays {
        let mappedValue = try [T].mappedInstance(value, context: map.context)
        mappedDictionaryOfArrays[key] = mappedValue
    }
    return mappedDictionaryOfArrays
}

public prefix func <~ <T: MappableObject>(map: Map) throws -> Set<T> {
    try enforceMapType(map, expectedType: .FromJson)
    let jsonArray = try expectJsonArrayWithMap(map, targetType: Set<T>.self)
    return try Set<T>.mappedInstance(jsonArray, context: map.context)
}

// MARK: Transformables

public prefix func <~ <JsonInputType, T>(transformer: FromJsonTransformer<JsonInputType, T>) throws -> T {
    try enforceMapType(transformer.map, expectedType: .FromJson)
    return try transformer.transformValue(transformer.map.result)
}

// MARK: Enforcers

private func enforceMapType(map: Map, expectedType: Map.OperationType) throws {
    if map.type != expectedType {
        throw logError(MappingError.UnexpectedOperationType("Received mapping operation of type: \(map.type) expected: \(expectedType)"))
    }
}

private func enforceResultExists<T>(map: Map, type: T.Type) throws -> AnyObject {
    if let result = map.result {
        return result
    } else {
        let message = "Key: \(map.lastKey) TargetType: \(T.self)"
        let error = SequenceError.FoundNil(message)
        throw logError(error)
    }
}

private func unexpectedResult<T, U>(result: Any, expected: T.Type, keyPath: KeyType, targetType: U.Type) -> ErrorType {
    let message = "Found: \(result) ofType: \(result.dynamicType) Expected: \(T.self) KeyPath: \(keyPath) TargetType: \(U.self)"
    let error = SequenceError.UnexpectedValue(message)
    return error
}

private func expectJsonArrayWithMap<T>(map: Map, targetType: T.Type) throws -> [JSON] {
    let result = try enforceResultExists(map, type: T.self)
    if let j = result as? [JSON] {
        return j
    } else if let j = result as? JSON {
        return [j]
    } else {
        let error = unexpectedResult(result, expected: [JSON].self, keyPath: map.lastKey, targetType: T.self)
        throw logError(error)
    }
}

private func expectJsonArrayOfArraysWithMap<T>(map: Map, targetType: T.Type) throws -> [[JSON]] {
    let result = try enforceResultExists(map, type: T.self)
    if let j = result as? [[JSON]] {
        return j
    } else if let j = result as? [JSON] {
        return [j]
    } else {
        let error = unexpectedResult(result, expected: [JSON].self, keyPath: map.lastKey, targetType: T.self)
        throw logError(error)
    }
}

private func expectJsonDictionaryWithMap<T>(map: Map, targetType: T.Type) throws -> [String : JSON] {
    let result = try enforceResultExists(map, type: T.self)
    if let j = result as? [String : JSON] {
        return j
    } else {
        let error = unexpectedResult(result, expected: [String : JSON].self, keyPath: map.lastKey, targetType: T.self)
        throw logError(error)
    }
}

private func expectJsonDictionaryOfArraysWithMap<T>(map: Map, targetType: T.Type) throws -> [String : [JSON]] {
    let result = try enforceResultExists(map, type: T.self)
    if let j = result as? [String : [JSON]] {
        return j
    } else {
        let error = unexpectedResult(result, expected: [String : JSON].self, keyPath: map.lastKey, targetType: T.self)
        throw logError(error)
    }
}
