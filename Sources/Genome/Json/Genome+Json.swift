//
//  Genome+Json.swift
//  Genome
//
//  Created by Logan Wright on 2/11/16.
//  Copyright © 2016 lowriDevs. All rights reserved.
//

import PureJsonSerializer

// MARK: BackingDataType

extension Json: BackingDataType {
    public var numberValue: Double? {
        return doubleValue
    }
    
    public init(_ node: Node) {
        switch node {
        case let .StringValue(str):
            self = .StringValue(str)
        case let .NumberValue(num):
            self = .NumberValue(num)
        case let .BooleanValue(bool):
            self = .BooleanValue(bool)
        case let .ArrayValue(arr):
            self = .ArrayValue(arr.map(Json.init))
        case let .ObjectValue(obj):
            var mutable: [String : Json] = [:]
            obj.forEach { key, val in
                mutable[key] = Json(val)
            }
            self = .ObjectValue(mutable)
        case .NullValue:
            self = .NullValue
        }
    }
    
    
    public static func makeWith(node: Node, context: Context) throws -> Json {
        return Json(node)
    }
    
    public func toNode() throws -> Node {
        switch self {
        case let .StringValue(str):
            return .StringValue(str)
        case let .NumberValue(num):
            return .NumberValue(num)
        case let .BooleanValue(bool):
            return .BooleanValue(bool)
        case let .ArrayValue(arr):
            let mapped = try arr.map { try $0.toNode() }
            return .ArrayValue(mapped)
        case let .ObjectValue(obj):
            var mutable: [String : Node] = [:]
            try obj.forEach { key, val in
                mutable[key] = try val.toNode()
            }
            return .ObjectValue(mutable)
        case .NullValue:
            return .NullValue
        }
    }
}

// MARK: Convenience

extension MappableBase {
    public func toJson() throws -> Json {
        let node = try toNode()
        return try node.toData()
    }
}

extension NodeConvertibleType {
    public func toJson() throws -> Json {
        let node = try toNode()
        return try node.toData()
    }
}

extension SequenceType where Generator.Element: NodeConvertibleType {
    public func toJson() throws -> Json {
        let array = try map { try $0.toJson() }
        return .init(array)
    }
}

extension Dictionary where Key: CustomStringConvertible, Value: NodeConvertibleType {
    public func toJson() throws -> Json {
        var mutable: [String : Json] = [:]
        try self.forEach { key, value in
            mutable["\(key)"] = try value.toJson()
        }
        return .ObjectValue(mutable)
    }
}

extension Map {
    public var json: Json {
        return Json(node)
    }
}

// MARK: Deprecations

extension MappableObject {
    public init(js: Json, context: Context = EmptyNode) throws {
        try self.init(node: js, context: context)
    }
}

public protocol JsonConvertibleType: NodeConvertibleType {
    static func makeWith(json: Json, context: Context) throws -> Self
    func toJson() throws -> Json
}

extension JsonConvertibleType {
    static func makeWith(node: Node, context: Context) throws -> Self {
        return try makeWith(node.toData(), context: context)
    }
    
    func toNode() throws -> Node {
        return try toJson().toNode()
    }
}

// MARK: Json

extension Json : JsonConvertibleType {
    public static func makeWith(json: Json, context: Context = EmptyNode) -> Json {
        return json
    }
    
    public func toJson() -> Json {
        return self
    }
}

// MARK: Deprecations

@available(*, deprecated=3.0, renamed="EmptyNode")
public let EmptyJson = Json.ObjectValue([:])

extension Map {
    @available(*, deprecated=3.0, renamed="init(node: context: default)")
    public convenience init(json: Json, context: Context = EmptyNode) throws {
        try self.init(data: json, context: context)
    }
}

extension Array where Element : JsonConvertibleType {
    @available(*, deprecated=3.0, renamed="init(node: context:)")
    public init(js: Json, context: Context = EmptyJson) throws {
        let array = js.arrayValue ?? [js]
        try self.init(js: array, context: context)
    }
    
    @available(*, deprecated=3.0, renamed="init(node: context:)")
    public init(js: [Json], context: Context = EmptyJson) throws {
        self = try js.map { try Element.makeWith($0, context: context) }
    }
}

extension Set where Element : JsonConvertibleType {
    @available(*, deprecated=3.0, renamed="init(node: context:)")
    public init(js: Json, context: Context = EmptyJson) throws {
        let array = js.arrayValue ?? [js]
        try self.init(js: array, context: context)
    }
    
    @available(*, deprecated=3.0, renamed="init(node: context:)")
    public init(js: [Json], context: Context = EmptyJson) throws {
        let array = try js.map { try Element.makeWith($0, context: context) }
        self.init(array)
    }
}

extension FromNodeTransformer {
    @available(*, deprecated=3.0, renamed="transformToNode")
    public func transformToJson<OutputJsonType: NodeConvertibleType>(transformer: TransformedType throws -> OutputJsonType) -> TwoWayTransformer<NodeType, TransformedType, OutputJsonType> {
        let toJsonTransformer = ToNodeTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromNodeTransformer: self, toNodeTransformer: toJsonTransformer)
    }
}

extension ToNodeTransformer {
    @available(*, deprecated=3.0, renamed="transformFromNode")
    public func transformFromJson<InputJsonType>(transformer: InputJsonType throws -> ValueType) -> TwoWayTransformer<InputJsonType, ValueType, OutputNodeType> {
        let fromJsonTransformer = FromNodeTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromNodeTransformer: fromJsonTransformer, toNodeTransformer: self)
    }
    
    @available(*, deprecated=3.0, renamed="transformFromNode")
    public func transformFromJson<InputJsonType>(transformer: InputJsonType? throws -> ValueType) -> TwoWayTransformer<InputJsonType, ValueType, OutputNodeType> {
        let fromJsonTransformer = FromNodeTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromNodeTransformer: fromJsonTransformer, toNodeTransformer: self)
    }
}

public extension Map {
    @available(*, deprecated=3.0, renamed="transformFromNode")
    public func transformFromJson<JsonType: NodeConvertibleType, TransformedType>(transformer: JsonType throws -> TransformedType) -> FromNodeTransformer<JsonType, TransformedType> {
        return FromNodeTransformer(map: self, transformer: transformer)
    }
    
    @available(*, deprecated=3.0, renamed="transformFromNode")
    public func transformFromJson<JsonType: NodeConvertibleType, TransformedType>(transformer: JsonType? throws -> TransformedType) -> FromNodeTransformer<JsonType, TransformedType> {
        return FromNodeTransformer(map: self, transformer: transformer)
    }
    
    @available(*, deprecated=3.0, renamed="transformToNode")
    public func transformToJson<ValueType, JsonOutputType: NodeConvertibleType>(transformer: ValueType throws -> JsonOutputType) -> ToNodeTransformer<ValueType, JsonOutputType> {
        return ToNodeTransformer(map: self, transformer: transformer)
    }
}