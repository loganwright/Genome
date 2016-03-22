//
//  Node+Foundation.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 1/21/16.
//  Copyright (c) 2014 Fuji Goro. All rights reserved.
//

import Foundation

extension Node {
    public init(_ any: AnyObject) {
        switch any {
            // If we're coming from foundation, it will be an `NSNumber`.
            //This represents double, integer, and boolean.
        case let number as Double:
            self = .NumberValue(number)
        case let string as String:
            self = .StringValue(string)
        case let object as [String : AnyObject]:
            self = Node(object)
        case let array as [AnyObject]:
            self = .ArrayValue(array.map(Node.init))
        case _ as NSNull:
            self = .NullValue
        default:
            fatalError("Unsupported foundation type")
        }
    }
    
    public init(_ any: [String : AnyObject]) {
        var mutable: [String : Node] = [:]
        any.forEach { key, val in
            mutable[key] = Node(val)
        }
        self = .ObjectValue(mutable)
    }
    
    public init(_ any: [AnyObject]) {
        let array = any.map(Node.init)
        self = .ArrayValue(array)
    }
    
    public var anyValue: AnyObject {
        switch self {
        case .ObjectValue(let ob):
            var mapped: [String : AnyObject] = [:]
            ob.forEach { key, val in
                mapped[key] = val.anyValue
            }
            return mapped
        case .ArrayValue(let array):
            return array.map { $0.anyValue }
        case .BooleanValue(let bool):
            return bool
        case .NumberValue(let number):
            return number
        case .StringValue(let string):
            return string
        case .NullValue:
            return NSNull()
        }
    }
}

extension NodeConvertibleType {
    static func makeWith(node: AnyObject, context: Context = EmptyNode) throws -> Self {
        return try makeWith(Node(node), context: context)
    }
}

extension MappableBase {
    public func foundationJson() throws -> AnyObject {
        return try toNode().anyValue
    }
    
    public func foundationDictionary() throws -> [String : AnyObject]? {
        return try foundationJson() as? [String : AnyObject]
    }
    
    public func foundationArray() throws -> [AnyObject]? {
        return try foundationJson() as? [AnyObject]
    }
}


public extension Array where Element : NodeConvertibleType {
    public init(node: AnyObject, context: Context = EmptyNode) throws {
        let array = node as? [AnyObject] ?? [node]
        try self.init(node: array, context: context)
    }
    
    public init(node: [AnyObject], context: Context = EmptyNode) throws {
        self = try node.map { try Element.makeWith($0, context: context) }
    }
}

public extension Set where Element : NodeConvertibleType {
    public init(node: AnyObject, context: Context = EmptyNode) throws {
        let array = node as? [AnyObject] ?? [node]
        try self.init(node: array, context: context)
    }
    
    public init(node: [AnyObject], context: Context = EmptyNode) throws {
        let array = try node.map { try Element.makeWith($0, context: context) }
        self.init(array)
    }
}
