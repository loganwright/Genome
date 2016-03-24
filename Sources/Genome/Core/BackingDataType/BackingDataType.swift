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
    
    static func makeWith(node: Node, context: Context) throws -> Self
    func toNode() throws -> Node
    
    // Optional
    var doubleValue: Double? { get }
    var floatValue: Float? { get }
    var intValue: Int? { get }
    var uintValue: UInt? { get }
}

// MARK: Number Values

extension BackingDataType {
    public var doubleValue: Double? {
        return numberValue
    }
    
    public var floatValue: Float? {
        return numberValue.flatMap(Float.init)
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
    public init(_ node: Node) {
        self = node
    }
}

extension Node {
    public func toData<T: BackingDataType>() throws -> T {
        return try T.makeWith(self)
    }
}

// MARK: Node Convertible

extension NodeConvertibleType {
    static func makeWith<T: BackingDataType>(node: T, context: Context = EmptyNode) throws -> Self {
        return try makeWith(try node.toNode(), context: context)
    }
}

// MARK: Mappable Object

extension MappableObject {
    public init<T: BackingDataType>(node: T, context: Context = EmptyNode) throws {
        let safeNode = try node.toNode()
        try self.init(node: safeNode, context: context)
    }
    
    public init<T: BackingDataType>(node: [String : T], context: [String : AnyObject] = [:]) throws {
        var mapped: [String : Node] = [:]
        try node.forEach { key, value in
            mapped[key] = try value.toNode()
        }
    
        let node = Node(mapped)
        try self.init(node: node, context: context)
    }
    
    // NodeConvertibleTypeConformance
    public static func makeWith<T: BackingDataType>(data data: T, context: Context = EmptyNode) throws -> Self {
        let node = try data.toNode()
        guard let _ = node.objectValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        return try self.init(node: node, context: context)
    }
}
