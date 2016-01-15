//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

import PureJsonSerializer

// MARK: Transformer Base

public class Transformer<InputType, OutputType> {
    
    internal let map: Map
    internal let transformer: InputType? throws -> OutputType

    private var allowsNil: Bool
    
    public init(map: Map, transformer: InputType throws -> OutputType) {
        self.map = map
        self.transformer = { input in
            return try transformer(input!)
        }
        self.allowsNil = false
    }
    
    public init(map: Map, transformer: InputType? throws -> OutputType) {
        self.map = map
        self.transformer = transformer
        self.allowsNil = true
    }
    
    internal func transformValue<T>(value: T) throws -> OutputType {
        if let input = value as? InputType {
            return try transformer(input)
        } else {
            throw logError(unexpectedInput(value))
        }
    }
    
    internal func transformValue<T>(value: T?) throws -> OutputType {
        if allowsNil {
            guard let unwrapped = value else { return try transformer(nil) }
            return try transformValue(unwrapped)
        } else {
            let unwrapped = try enforceValueExists(value)
            return try transformValue(unwrapped)
        }
        
    }
    
    private func unexpectedInput<ValueType>(value: ValueType) -> ErrorType {
        let message = "Unexpected Input: \(value) ofType: \(ValueType.self) Expected: \(InputType.self) KeyPath: \(map.lastKey)"
        return TransformationError.UnexpectedInputType(message)
    }
    
    private func enforceValueExists<T>(value: T?) throws -> T {
        if let unwrapped = value {
            return unwrapped
        } else {
            let error = TransformationError.UnexpectedInputType("Unexpectedly found nil input.  KeyPath: \(map.lastKey) Expected: \(InputType.self)")
            throw logError(error)
        }
    }
}


// MARK: From Json

public final class FromJsonTransformer<JsonType: JsonConvertibleType, TransformedType> : Transformer<JsonType, TransformedType> {
    override public init(map: Map, transformer: JsonType throws -> TransformedType) {
        super.init(map: map, transformer: transformer)
    }
    
    override public init(map: Map, transformer: JsonType? throws -> TransformedType) {
        super.init(map: map, transformer: transformer)
    }
    
    public func transformToJson<OutputJsonType: JsonConvertibleType>(transformer: TransformedType throws -> OutputJsonType) -> TwoWayTransformer<JsonType, TransformedType, OutputJsonType> {
        let toJsonTransformer = ToJsonTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromJsonTransformer: self, toJsonTransformer: toJsonTransformer)
    }
    
    internal func transformValue(json: Json?) throws -> TransformedType {
        let validJson: Json
        if allowsNil {
            guard let unwrapped = json else { return try transformer(nil) }
            validJson = unwrapped
        } else {
            validJson = try enforceValueExists(json)
        }
        
        let input = try JsonType.newInstance(validJson, context: validJson)
        return try transformer(input)
    }
}

// MARK: To Json

public final class ToJsonTransformer<ValueType, OutputJsonType: JsonConvertibleType> : Transformer<ValueType, OutputJsonType> {
    override public init(map: Map, transformer: ValueType throws -> OutputJsonType) {
        super.init(map: map, transformer: transformer)
    }
    
    func transformFromJson<InputJsonType>(transformer: InputJsonType throws -> ValueType) -> TwoWayTransformer<InputJsonType, ValueType, OutputJsonType> {
        let fromJsonTransformer = FromJsonTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromJsonTransformer: fromJsonTransformer, toJsonTransformer: self)
    }
    
    func transformFromJson<InputJsonType>(transformer: InputJsonType? throws -> ValueType) -> TwoWayTransformer<InputJsonType, ValueType, OutputJsonType> {
        let fromJsonTransformer = FromJsonTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromJsonTransformer: fromJsonTransformer, toJsonTransformer: self)
    }
    
    internal func transformValue(value: ValueType) throws -> Json {
        let transformed = try transformer(value)
        return try transformed.jsonRepresentation()
    }
}

// MARK: Two Way Transformer

public final class TwoWayTransformer<InputJsonType: JsonConvertibleType, TransformedType, OutputJsonType: JsonConvertibleType> {
    
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
    public func transformFromJson<JsonType: JsonConvertibleType, TransformedType>(transformer: JsonType throws -> TransformedType) -> FromJsonTransformer<JsonType, TransformedType> {
        return FromJsonTransformer(map: self, transformer: transformer)
    }
    
    public func transformFromJson<JsonType: JsonConvertibleType, TransformedType>(transformer: JsonType? throws -> TransformedType) -> FromJsonTransformer<JsonType, TransformedType> {
        return FromJsonTransformer(map: self, transformer: transformer)
    }
    
    public func transformToJson<ValueType, JsonOutputType: JsonConvertibleType>(transformer: ValueType throws -> JsonOutputType) -> ToJsonTransformer<ValueType, JsonOutputType> {
        return ToJsonTransformer(map: self, transformer: transformer)
    }
}

// MARK: Operators

public func <~> <T: JsonConvertibleType, JsonInputType>(inout lhs: T, rhs: FromJsonTransformer<JsonInputType, T>) throws {
    switch rhs.map.type {
    case .FromJson:
        try lhs <~ rhs
    case .ToJson:
        try lhs ~> rhs.map
    }
}

public func <~> <T: JsonConvertibleType, JsonOutputType: JsonConvertibleType>(inout lhs: T, rhs: ToJsonTransformer<T, JsonOutputType>) throws {
    switch rhs.map.type {
    case .FromJson:
        try lhs <~ rhs.map
    case .ToJson:
        try lhs ~> rhs
    }
}

public func <~> <JsonInput, TransformedType, JsonOutput: JsonConvertibleType>(inout lhs: TransformedType, rhs: TwoWayTransformer<JsonInput, TransformedType, JsonOutput>) throws {
    switch rhs.map.type {
    case .FromJson:
        try lhs <~ rhs.fromJsonTransformer
    case .ToJson:
        try lhs ~> rhs.toJsonTransformer
    }
}

public func <~ <T, JsonInputType: JsonConvertibleType>(inout lhs: T, rhs: FromJsonTransformer<JsonInputType, T>) throws {
    switch rhs.map.type {
    case .FromJson:
        try lhs = rhs.transformValue(rhs.map.result)
    case .ToJson:
        break
    }
}

public func ~> <T, JsonOutputType: JsonConvertibleType>(lhs: T, rhs: ToJsonTransformer<T, JsonOutputType>) throws {
    switch rhs.map.type {
    case .FromJson:
        break
    case .ToJson:
        let output = try rhs.transformValue(lhs)
        try rhs.map.setToLastKey(output)
    }
}
