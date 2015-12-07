
// MARK: Casting

prefix operator <~ {}
prefix operator <~? {}

extension Map {
    
    // MARK: Optional Extractions
    
    public func extract<T : JSONDataType>(keyType: KeyType) throws -> T? {
        return try <~self[keyType]
    }
    
    public func extract<T : JSONDataType>(keyType: KeyType) throws -> [T]? {
        return try <~self[keyType]
    }
    
    public func extract<T : JSONDataType>(keyType: KeyType) throws -> [[T]]? {
        return try <~self[keyType]
    }
    
    public func extract<T : JSONDataType>(keyType: KeyType) throws -> [String : T]? {
        return try <~self[keyType]
    }
    
    public func extract<T : JSONDataType>(keyType: KeyType) throws -> [String : [T]]? {
        return try <~self[keyType]
    }
    
    public func extract<T : JSONDataType>(keyType: KeyType) throws -> Set<T>? {
        return try <~self[keyType]
    }
    
    // MARK: Non Optional Extractions
    
    public func extract<T : JSONDataType>(keyType: KeyType) throws -> T {
        return try <~self[keyType]
    }
    
    public func extract<T : JSONDataType>(keyType: KeyType) throws -> [T] {
        return try <~self[keyType]
    }
    
    public func extract<T : JSONDataType>(keyType: KeyType) throws -> [[T]] {
        return try <~self[keyType]
    }
    
    public func extract<T : JSONDataType>(keyType: KeyType) throws -> [String : T] {
        return try <~self[keyType]
    }
    
    public func extract<T : JSONDataType>(keyType: KeyType) throws -> [String : [T]] {
        return try <~self[keyType]
    }
    
    public func extract<T : JSONDataType>(keyType: KeyType) throws -> Set<T> {
        return try <~self[keyType]
    }

}

// MARK: Optional Casters

@available(*, deprecated=1.0.9, renamed="<~")
public prefix func <~? <T: JSONDataType>(map: Map) throws -> T? {
    return try <~map
}

@available(*, deprecated=1.0.9, renamed="<~")
public prefix func <~? <T: JSONDataType>(map: Map) throws -> [T]? {
    return try <~map
}

@available(*, deprecated=1.0.9, renamed="<~")
public prefix func <~? <T: JSONDataType>(map: Map) throws -> [[T]]? {
    return try <~map
}

@available(*, deprecated=1.0.9, renamed="<~")
public prefix func <~? <T: JSONDataType>(map: Map) throws -> [String : T]? {
    return try <~map
}

@available(*, deprecated=1.0.9, renamed="<~")
public prefix func <~? <T: JSONDataType>(map: Map) throws -> [String : [T]]? {
    return try <~map
}

@available(*, deprecated=1.0.9, renamed="<~")
public prefix func <~? <T: JSONDataType>(map: Map) throws -> Set<T>? {
    return try <~map
}

/// ****

public prefix func <~ <T: JSONDataType>(map: Map) throws -> T? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as T
}

public prefix func <~ <T: JSONDataType>(map: Map) throws -> [T]? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [T]
}

public prefix func <~ <T: JSONDataType>(map: Map) throws -> [[T]]? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [[T]]
}
public prefix func <~ <T: JSONDataType>(map: Map) throws -> [String : T]? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [String : T]
}
public prefix func <~ <T: JSONDataType>(map: Map) throws -> [String : [T]]? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as [String : [T]]
}
public prefix func <~ <T: JSONDataType>(map: Map) throws -> Set<T>? {
    try enforceMapType(map, expectedType: .FromJson)
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try <~map as Set<T>
}

// MARK: Non-Optional Casters

public prefix func <~ <T: JSONDataType>(map: Map) throws -> T {
    try enforceMapType(map, expectedType: .FromJson)
    let result = try enforceResultExists(map, type: T.self)
    do {
        return try T.newInstance(result, context: map.context)
    } catch {
        let error = MappingError._UnableToMap(key: map.lastKey, error: error)
        throw logError(error)
    }
}

public prefix func <~ <T: JSONDataType>(map: Map) throws -> [T] {
    try enforceMapType(map, expectedType: .FromJson)
    let result = try enforceResultExists(map, type: T.self)
    let rawArray = convertAnyObjectToRawArray(result)
    return try [T].newInstance(rawArray, context: map.context)
}

public prefix func <~ <T: JSONDataType>(map: Map) throws -> [[T]] {
    try enforceMapType(map, expectedType: .FromJson)
    let jsonArrayOfArrays = try _expectJsonArrayOfArraysWithMap(map, targetType: [[T]].self)
    return try jsonArrayOfArrays.map { try [T].newInstance($0, context: map.context) }
}

public prefix func <~ <T: JSONDataType>(map: Map) throws -> [String : T] {
    try enforceMapType(map, expectedType: .FromJson)
    let jsonDictionary = try _expectJsonDictionaryWithMap(map, targetType: [String : T].self)
    
    var mappedDictionary: [String : T] = [:]
    for (key, value) in jsonDictionary {
        let mappedValue = try T.newInstance(value, context: map.context)
        mappedDictionary[key] = mappedValue
    }
    return mappedDictionary
}

public prefix func <~ <T: JSONDataType>(map: Map) throws -> [String : [T]] {
    try enforceMapType(map, expectedType: .FromJson)
    let jsonDictionaryOfArrays = try _expectJsonDictionaryOfArraysWithMap(map, targetType: [String : [T]].self)
    
    var mappedDictionaryOfArrays: [String : [T]] = [:]
    for (key, value) in jsonDictionaryOfArrays {
        let mappedValue = try [T].newInstance(value, context: map.context)
        mappedDictionaryOfArrays[key] = mappedValue
    }
    return mappedDictionaryOfArrays
}

public prefix func <~ <T: JSONDataType>(map: Map) throws -> Set<T> {
    try enforceMapType(map, expectedType: .FromJson)
    let jsonArray = try _expectJsonArrayWithMap(map, targetType: Set<T>.self)
    return try Set<T>.newInstance(jsonArray, context: map.context)
}

// MARK: Transformables

public prefix func <~ <JsonInputType, T>(transformer: FromJsonTransformer<JsonInputType, T>) throws -> T {
    try enforceMapType(transformer.map, expectedType: .FromJson)
    return try transformer.transformValue(transformer.map.result)
}

// MARK: Enforcers

internal func enforceMapType(map: Map, expectedType: Map.OperationType) throws {
    if map.type != expectedType {
        throw logError(MappingError.UnexpectedOperationType("Received mapping operation of type: \(map.type) expected: \(expectedType)"))
    }
}

internal func enforceResultExists<T>(map: Map, type: T.Type) throws -> AnyObject {
    if let result = map.result {
        return result
    } else {
        let message = "Key: \(map.lastKey) TargetType: \(T.self)"
        let error = SequenceError.FoundNil(message)
        throw logError(error)
    }
}

internal func unexpectedResult<T, U>(result: Any, expected: T.Type, keyPath: KeyType, targetType: U.Type) -> ErrorType {
    let message = "Found: \(result) ofType: \(result.dynamicType) Expected: \(T.self) KeyPath: \(keyPath) TargetType: \(U.self)"
    let error = SequenceError.UnexpectedValue(message)
    return error
}


private func _expectJsonArrayWithMap<T>(map: Map, targetType: T.Type) throws -> [AnyObject] {
    let result = try enforceResultExists(map, type: T.self)
    return result as? [AnyObject] ?? [result]
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

private func _expectJsonArrayOfArraysWithMap<T>(map: Map, targetType: T.Type) throws -> [[AnyObject]] {
    let result = try enforceResultExists(map, type: T.self)
    if let j = result as? [[AnyObject]] {
        return j
    } else if let j = result as? [AnyObject] {
        return [j]
    } else {
        let error = unexpectedResult(result, expected: [AnyObject].self, keyPath: map.lastKey, targetType: T.self)
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

private func _expectJsonDictionaryWithMap<T>(map: Map, targetType: T.Type) throws -> [String : AnyObject] {
    let result = try enforceResultExists(map, type: T.self)
    if let j = result as? [String : AnyObject] {
        return j
    } else {
        let error = unexpectedResult(result, expected: [String : AnyObject].self, keyPath: map.lastKey, targetType: T.self)
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

private func _expectJsonDictionaryOfArraysWithMap<T>(map: Map, targetType: T.Type) throws -> [String : [AnyObject]] {
    let result = try enforceResultExists(map, type: T.self)
    if let j = result as? [String : [AnyObject]] {
        return j
    } else {
        let error = unexpectedResult(result, expected: [String : AnyObject].self, keyPath: map.lastKey, targetType: T.self)
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
