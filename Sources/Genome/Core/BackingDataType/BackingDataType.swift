//
//  BackingDataType.swift
//  Genome
//
//  Created by Logan Wright on 2/10/16.
//  Copyright © 2016 lowriDevs. All rights reserved.
//

import Foundation

// MARK: BackingDataType 

/**
*  Use this protocol for easy transformations to and from Node
*/
public protocol BackingDataType: NodeConvertibleType, Context {
    var isNull: Bool { get }
    var boolValue: Bool? { get }
    var numberValue: Double? { get }
    var stringValue: String? { get }
    var arrayValue: [Self]? { get }
    var objectValue: [String : Self]? { get }
    
    init(_ node: Node)
}

extension BackingDataType {
    public static func makeWith(node: Node, context: Context) throws -> Self {
        return self.init(node)
    }
    
    public func toNode() throws -> Node {
        return Node(self)
    }
}

// MARK: Number Values

extension BackingDataType {
    public var doubleValue: Double? {
        return numberValue
    }
    
    public var floatValue: Float? {
        guard let double = numberValue else { return nil }
        return Float(double)
    }
    
    public var intValue: Int? {
        guard let double = numberValue where double % 1 == 0 else {
            return nil
        }
        
        return Int(double)
    }
    
    public var uintValue: UInt? {
        guard let int = intValue where int >= 0 else { return nil }
        return UInt(int)
    }
}

// MARK: Node

extension Node: BackingDataType {
    public var numberValue: Double? {
        return doubleValue
    }
    
    public init(_ node: Node) {
        self = node
    }
}

extension Node {
    public func toData<T: BackingDataType>() -> T {
        return T.init(self)
    }
}

extension Node {
    public init<T: BackingDataType>(_ data: T) {
        if let string = data.stringValue {
            self = .StringValue(string)
        } else if let number = data.numberValue {
            self = .NumberValue(number)
        } else if let bool = data.boolValue {
            self = .BooleanValue(bool)
        } else if let array = data.arrayValue {
            self = .ArrayValue(array.map(Node.init))
        } else if let object = data.objectValue {
            var mutable: [String : Node] = [:]
            object.forEach { key, val in
                mutable[key] = Node(val)
            }
            self = .ObjectValue(mutable)
        } else if data.isNull {
            self = Node.NullValue
        } else {
            fatalError("Unable to convert data: \(data)")
        }
    }
}

// MARK: Node Convertible

extension NodeConvertibleType {
    static func makeWith<T: BackingDataType>(node: T, context: Context = EmptyNode) throws -> Self {
        return try makeWith(Node(node), context: context)
    }
}

// MARK: Mappable Object

extension MappableObject {
    public init<T: BackingDataType>(node: T, context: Context = EmptyNode) throws {
        let safeNode = Node(node)
        try self.init(node: safeNode, context: context)
    }
    
    public init<T: BackingDataType>(node: [String : T], context: [String : AnyObject] = [:]) throws {
        var mapped: [String : Node] = [:]
        node.forEach { key, value in
            mapped[key] = Node(value)
        }
    
        let node = Node(mapped)
        try self.init(node: node, context: context)
    }
    
    // NodeConvertibleTypeConformance
    public static func makeWith<T: BackingDataType>(data data: T, context: Context = EmptyNode) throws -> Self {
        let node = Node(data)
        guard let _ = node.objectValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        return try self.init(node: node, context: context)
    }
}
