//
//  Genome+Json.swift
//  Genome
//
//  Created by Logan Wright on 2/11/16.
//  Copyright © 2016 lowriDevs. All rights reserved.
//

@_exported import PureJson
@_exported import Genome

// MARK: BackingData

extension Json: BackingData {
    public func toNode() -> Node {
        switch self {
        case let .StringValue(str):
            return .string(str)
        case let .NumberValue(num):
            return .number(num)
        case let .BooleanValue(bool):
            return .bool(bool)
        case let .ArrayValue(arr):
            let mapped = arr.map { $0.toNode() }
            return .array(mapped)
        case let .ObjectValue(obj):
            var mutable: [String : Node] = [:]
            obj.forEach { key, val in
                mutable[key] = val.toNode()
            }
            return .object(mutable)
        case .NullValue:
            return .null
        }
    }

    public init(with node: Node, in context: Context) {
        switch node {
        case let .string(str):
            self = .StringValue(str)
        case let .number(num):
            self = .NumberValue(num)
        case let .bool(bool):
            self = .BooleanValue(bool)
        case let .array(arr):
            let mapped = arr.map { Json(with: $0, in: context) }
            self = .ArrayValue(mapped)
        case let .object(obj):
            var mutable: [String : Json] = [:]
            obj.forEach { key, val in
                mutable[key] = Json(with: val, in: context)
            }
            self = .ObjectValue(mutable)
        case .null:
            self = .NullValue
        }
    }
}

extension Json {
    public init(with node: Node) {
        self.init(with: node, in: EmptyNode)
    }
}

// MARK: Convenience

extension MappableBase {
    public func toJson() throws -> Json {
        let node = try toNode()
        return try node.toData()
    }
}

extension NodeConvertible {
    public func toJson() throws -> Json {
        let node = try toNode()
        return try node.toData()
    }
}

extension Sequence where Iterator.Element: NodeConvertible {
    public func toJson() throws -> Json {
        let array = try map { try $0.toJson() }
        return .init(array)
    }
}

extension Dictionary where Key: CustomStringConvertible, Value: NodeConvertible {
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
        return Json(with: node, in: node)
    }
}
