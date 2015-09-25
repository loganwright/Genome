import Foundation

// MARK: Casting

prefix operator * {}
prefix operator *? {}

// MARK: Optional Casters

public prefix func *? <T>(map: Map) throws -> T? {
    assert(map.type == .FromJson)
    guard
        let _ = map.result
        else {
            return nil
    }
    
    let nonOptional: T = try *map
    return nonOptional
}

public prefix func *? <T: MappableObject>(map: Map) throws -> T? {
    assert(map.type == .FromJson)
    guard
        let _ = map.result
        else {
            return nil
    }
    
    let nonOptional: T = try *map
    return nonOptional
}

public prefix func *? <T: MappableObject>(map: Map) throws -> [T]? {
    assert(map.type == .FromJson)
    guard
        let _ = map.result
        else {
            return nil
    }
    
    let nonOptional: [T] = try *map
    return nonOptional
}

// MARK: Non-Optional Casters

public prefix func * <T>(map: Map) throws -> T! {
    assert(map.type == .FromJson)
    guard
        let result = map.result
        else {
            throw logError(SequenceError.FoundNil("Key: \(map.lastKeyPath) ObjectType: \(T.self)"))
        }
    
    if let value = result as? T {
        return value
    } else {
        let error = SequenceError.UnexpectedValue("Found: \(result) ofType: \(result.dynamicType) Expected: \(T.self) KeyPath: \(map.lastKeyPath) ObjectType: \(T!.self)")
        throw logError(error)
    }
}

public prefix func * <T: MappableObject>(map: Map) throws -> T! {
    assert(map.type == .FromJson)
    guard
        let result = map.result
        else {
            throw logError(SequenceError.FoundNil("Key: \(map.lastKeyPath) ObjectType: \(T.self)"))
        }
    
    if let json = result as? JSON {
        return try T.mappedInstance(json, context: map.context)
    } else {
        let error = SequenceError.UnexpectedValue("Found: \(result) ofType: \(result.dynamicType) Expected: \(T.self) KeyPath: \(map.lastKeyPath) ObjectType: \([T].self)")
        throw logError(error)
    }
}

public prefix func * <T: MappableObject>(map: Map) throws -> [T]! {
    assert(map.type == .FromJson)
    guard
        let result = map.result
        else {
            throw logError(SequenceError.FoundNil("Key: \(map.lastKeyPath) ObjectType: \(T.self)"))
        }
    
    let jsonArray: [JSON]
    if let j = result as? [JSON] {
        jsonArray = j
    } else if let j = result as? JSON {
        jsonArray = [j]
    } else {
        let error = SequenceError.UnexpectedValue("Found: \(result) ofType: \(result.dynamicType) Expected: \(T.self) KeyPath: \(map.lastKeyPath) ObjectType: \([T].self)")
        throw logError(error)
    }
    
    return try [T].mappedInstance(jsonArray, context: map.context)
}

// MARK: Transformables

public prefix func * <JsonInputType, T>(transformer: FromJsonTransformer<JsonInputType, T>) throws -> T {
    return try transformer.transformValue(transformer.map.result)
}
