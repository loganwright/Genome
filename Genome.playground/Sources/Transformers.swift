//
//  TransformerOperators.swift
//  Genome
//
//  Created by Logan Wright on 7/31/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import Foundation

// MARK: Transformer Base

public class Transformer<InputType, OutputType> {
    internal let map: Map
    internal let transformer: InputType throws -> OutputType
    
    public init(map: Map, transformer: InputType throws -> OutputType) {
        self.map = map
        self.transformer = transformer
    }
    
    internal func transformValue<T>(value: T) throws -> OutputType {
        guard
            let input = value as? InputType
            else {
                let error = TransformationError.UnexpectedInputType("Unexpected Input: \(value) ofType: \(value.dynamicType) Expected: \(InputType.self) KeyPath: \(map.lastKeyPath)")
                throw logError(error)
        }
        
        return try transformer(input)
    }
    
    internal func transformValue<T>(value: T?) throws -> OutputType {
        guard
            let input = value as? InputType
            else {
                let error = TransformationError.UnexpectedInputType("Unexpected Input: \(value) ofType: \(value.dynamicType) Expected: \(InputType.self) KeyPath: \(map.lastKeyPath)")
                throw logError(error)
        }
        
        return try transformer(input)
    }
}

// MARK: From Json

public final class FromJsonTransformer<JsonType, TransformedType> : Transformer<JsonType, TransformedType> {
    override public init(map: Map, transformer: JsonType throws -> TransformedType) {
        super.init(map: map, transformer: transformer)
    }
    
    public func transformToJson<OutputJsonType>(transformer: TransformedType throws -> OutputJsonType) -> TwoWayTransformer<JsonType, TransformedType, OutputJsonType> {
        let toJsonTransformer = ToJsonTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromJsonTransformer: self, toJsonTransformer: toJsonTransformer)
    }
}

public final class ToJsonTransformer<ValueType, OutputJsonType> : Transformer<ValueType, OutputJsonType> {
    override public init(map: Map, transformer: ValueType throws -> OutputJsonType) {
        super.init(map: map, transformer: transformer)
    }
    
    func transformFromJson<InputJsonType>(transformer: InputJsonType throws -> ValueType) -> TwoWayTransformer<InputJsonType, ValueType, OutputJsonType> {
        let fromJsonTransformer = FromJsonTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromJsonTransformer: fromJsonTransformer, toJsonTransformer: self)
    }
}

// MARK: Two Way Transformer

public final class TwoWayTransformer<InputJsonType, TransformedType, OutputJsonType> {
    
    var map: Map {
        let toMap = toJsonTransformer.map
        return toMap
    }
    
    public let fromJsonTransformer: FromJsonTransformer<InputJsonType, TransformedType>
    public let toJsonTransformer: ToJsonTransformer<TransformedType, OutputJsonType>
    
    public init(fromJsonTransformer: FromJsonTransformer<InputJsonType, TransformedType>, toJsonTransformer: ToJsonTransformer<TransformedType, OutputJsonType>) {
        self.fromJsonTransformer = fromJsonTransformer
        self.toJsonTransformer = toJsonTransformer
    }
}

// MARK: Map Extensions

public extension Map {
    public func transformFromJson<JsonType, TransformedType>(transformer: JsonType throws -> TransformedType) -> FromJsonTransformer<JsonType, TransformedType> {
        return FromJsonTransformer(map: self, transformer: transformer)
    }
    
    public func transformToJson<ValueType, JsonOutputType>(transformer: ValueType throws -> JsonOutputType) -> ToJsonTransformer<ValueType, JsonOutputType> {
        return ToJsonTransformer(map: self, transformer: transformer)
    }
}

// MARK: Operators

public func <~> <T, JsonInputType>(inout lhs: T, rhs: FromJsonTransformer<JsonInputType, T>) throws {
    switch rhs.map.type {
    case .FromJson:
        try lhs <~ rhs
    case .ToJson:
        try lhs ~> rhs.map
    }
}

public func <~> <T, JsonOutputType>(inout lhs: T, rhs: ToJsonTransformer<T, JsonOutputType>) throws {
    switch rhs.map.type {
    case .FromJson:
        try lhs <~ rhs.map
    case .ToJson:
        try lhs ~> rhs
    }
}

public func <~> <JsonInput, TransformedType, JsonOutput>(inout lhs: TransformedType, rhs: TwoWayTransformer<JsonInput, TransformedType, JsonOutput>) throws {
    switch rhs.map.type {
    case .FromJson:
        try lhs <~> rhs.fromJsonTransformer
    case .ToJson:
        try lhs <~> rhs.toJsonTransformer
    }
}

public func <~ <T, JsonInputType>(inout lhs: T, rhs: FromJsonTransformer<JsonInputType, T>) throws {
    switch rhs.map.type {
    case .FromJson:
        try lhs = rhs.transformValue(rhs.map.result)
    case .ToJson:
        break
    }
}

public func ~> <T, JsonOutputType>(lhs: T, rhs: ToJsonTransformer<T, JsonOutputType>) throws {
    switch rhs.map.type {
    case .FromJson:
        break
    case .ToJson:
        let output = try rhs.transformValue(lhs)
        try rhs.map.setToLastKey(output)
    }
}
