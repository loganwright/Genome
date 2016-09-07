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

// MARK: Settable Operators

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> T? {
    try map.expectFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try execute(with: map,
                       body: <~map as T)
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [T]? {
    try map.expectFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try execute(with: map,
                       body: <~map as [T])
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [[T]]? {
    try map.expectFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try execute(with: map,
                       body: <~map as [[T]])
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [String : T]? {
    try map.expectFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try execute(with: map,
                       body: <~map as [String : T])
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> [String : [T]]? {
    try map.expectFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try execute(with: map,
                       body: <~map as [String : [T]])
}

public prefix func <~ <T: NodeConvertible>(map: Map) throws -> Set<T>? {
    try map.expectFromNode()
    guard let _ = map.result else { return nil } // Ok for Optionals to return nil
    return try execute(with: map,
                       body: <~map as Set<T>)
}

// MARK: Non-Optional Casters

public prefix func <~ <T: NodeInitializable>(map: Map) throws -> T {
    let result = try map.expectResult(targeting: T.self)
    return try execute(with: map,
                       body: T.init(node: result, in: map.context))
}

public prefix func <~ <T: NodeInitializable>(map: Map) throws -> [T] {
    let result = try map.expectResult(targeting: [T].self)
    return try execute(with: map,
                       body: [T].init(node: result, in: map.context))
}

public prefix func <~ <T: NodeInitializable>(map: Map) throws -> Set<T> {
    let result = try map.expectResult(targeting: T.self)
    let mapped = try execute(with: map,
                             body: [T].init(node: result, in: map.context))
    return Set<T>(mapped)
}

public prefix func <~ <T: NodeInitializable>(map: Map) throws -> [[T]] {
    let result = try map.expectResult(targeting: [[T]].self)
    let array = result.arrayOfArrays
    return try execute(with: map,
                       body: array.map { try [T].init(node: $0, in: map.context) })
}

public prefix func <~ <T: NodeInitializable>(map: Map) throws -> [String : T] {
    let nodeDictionary = try execute(with: map,
                                     body: map.expectNodeDictionary(targeting: [String : T].self))
    
    var mapped: [String : T] = [:]
    for (key, value) in nodeDictionary {
        mapped[key] = try execute(with: map,
                                  body: T.init(node: value, in: map.context))
    }
    return mapped
}

public prefix func <~ <T: NodeInitializable>(map: Map) throws -> [String : [T]] {
    let type = [String : [T]].self
    let nodeDictionaryOfArrays = try execute(with: map,
                                             body: map.expectNodeDictionary(targeting: type))

    var mapped: [String : [T]] = [:]
    for (key, value) in nodeDictionaryOfArrays {
        mapped[key] = try execute(with: map,
                                  body: [T].init(node: value, in: map.context))
    }
    return mapped
}

// MARK: Transformables

public prefix func <~ <NodeInputType: NodeConvertible, T>(transformer: FromNodeTransformer<NodeInputType, T>) throws -> T {
    try transformer.map.expectFromNode()
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
private func execute<T>(with map: Map, body: @autoclosure (Void) throws -> T) throws -> T {
    do {
        return try body()
    } catch let e as Error {
        throw e.appendLastKeyPath(map.lastPath)
    } catch {
        throw error
    }
}

// MARK: Enforcers

extension Map {
    fileprivate func expectFromNode() throws {
        try type.assert(equals: .fromNode)
    }

    fileprivate func expectResult<T>(targeting: T.Type) throws -> Node {
        try expectFromNode()
        if let result = self.result {
            return result
        } else {
            throw ErrorFactory.foundNil(for: lastPath,
                                        expected: T.self)
        }
    }
}

extension Map {
    fileprivate func expectNodeDictionary<T>(targeting: T.Type) throws -> [String : Node] {
        let result = try expectResult(targeting: T.self)
        if let j = result.nodeObject {
            return j
        } else {
            throw ErrorFactory.unableToConvert(result, to: T.self)
        }
    }
}

extension Node {
    internal var arrayOfArrays: [[Node]] {
        let array = self.nodeArray ?? [self]
        let possibleArrayOfArrays = array.flatMap { $0.nodeArray }
        let isAlreadyAnArrayOfArrays = possibleArrayOfArrays.count == array.count
        let arrayOfArrays: [[Node]] = isAlreadyAnArrayOfArrays ? possibleArrayOfArrays : [array]
        return arrayOfArrays
    }
}
