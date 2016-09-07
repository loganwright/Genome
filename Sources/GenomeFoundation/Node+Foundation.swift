//
//  Node+Foundation.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 1/21/16.
//  Copyright (c) 2014 Fuji Goro. All rights reserved.
//

import Genome
import Foundation

#if Xcode
extension Node {
    /**
     Attempt to initialize a node with a foundation object.
     
     - warning: will default to null if unexpected value

     - parameter any: the object to create a node from

     - throws: if fails to create node.
     */
    public init(_ any: AnyObject) {
        switch any {
            // If we're coming from foundation, it will be an `NSNumber`.
            //This represents double, integer, and boolean.
        case let number as Double:
            // When coming from ObjC AnyObject, this will represent all Integer types and boolean
            self = .number(Node.Number(number))
        case let string as String:
            self = .string(string)
        case let object as [String : AnyObject]:
            self = Node(object)
        case let array as [AnyObject]:
            self = .array(array.map(Node.init))
        case _ as NSNull:
            self = .null
        case let bytes as NSData:
            var raw = [UInt8](repeating: 0, count: bytes.length)
            bytes.getBytes(&raw, length: bytes.length)
            self = .bytes(raw)
        default:
            self = .null
        }
    }

    /**
     Initialize a node with a foundation dictionary

     - parameter any: the dictionary to initialize with
     */
    public init(_ any: [String : AnyObject]) {
        var mutable: [String : Node] = [:]
        any.forEach { key, val in
            mutable[key] = Node(val)
        }
        self = .object(mutable)
    }

    /**
     Initialize a node with a foundation array

     - parameter any: the array to initialize with
     */
    public init(_ any: [AnyObject]) {
        let array = any.map(Node.init)
        self = .array(array)
    }

    /**
     Create an anyobject representation of the node, 
     intended for Foundation environments.
     */
    public var anyValue: AnyObject {
        switch self {
        case .object(let ob):
            var mapped: [String : AnyObject] = [:]
            ob.forEach { key, val in
                mapped[key] = val.anyValue
            }
            return mapped as AnyObject
        case .array(let array):
            return array.map { $0.anyValue } as AnyObject
        case .bool(let bool):
            return bool as AnyObject
        case .number(let number):
            return number.double as AnyObject
        case .string(let string):
            return string as AnyObject
        case .null:
            return NSNull()
        case .bytes(let bytes):
            var bytes = bytes
            let data = NSData(bytes: &bytes, length: bytes.count)
            return data
        }
    }
}

extension NodeConvertible {
    /**
     Create object w/ Foundation object

     - warning: expects an object (dictionary)

     - parameter node:    foundation object to map with
     - parameter context: context to map within

     - throws: if conversion fails
     */
    public init(node: AnyObject, in context: Context = EmptyNode) throws {
        try self.init(node: Node(node), in: context)
    }
}

extension MappableBase {
    /**
     Create a Foundation AnyObject representation 
     of the mappable object

     - throws: if mapping fails

     - returns: the foundation representation
     */
    public func foundationJSON() throws -> AnyObject {
        return try makeNode().anyValue
    }

    /**
     Create a foundation dictionary from the mappable object.

     - throws: if mapping fails

     - returns: the foundation representation as dictionary
     */
    public func foundationDictionary() throws -> [String : AnyObject]? {
        return try foundationJSON() as? [String : AnyObject]
    }

    /**
     Create a foundation array from the mappable object

     - throws: if mapping fails

     - returns: an array of type AnyObject
     */
    public func foundationArray() throws -> [AnyObject]? {
        return try foundationJSON() as? [AnyObject]
    }
}

public extension Array where Element : NodeConvertible {
    /**
     Initialize array of convertibles with object

     - warning: expects array or object as arg

     - parameter node:    object to initialize with
     - parameter context: context to initialize in

     - throws: if mapping fails
     */
    public init(node: AnyObject, in context: Context = EmptyNode) throws {
        let array = node as? [AnyObject] ?? [node]
        try self.init(node: array, in: context)
    }

    /**
     Initializes array of convertibles with array of objects

     - parameter node:    array
     - parameter context: context to initialize in

     - throws: if mapping fails
     */
    public init(node: [AnyObject], in context: Context = EmptyNode) throws {
        self = try node.map { try Element.init(node: $0, in: context) }
    }
}

public extension Set where Element : NodeConvertible {
    /**
     Initialize set of convertibles with object

     - warning: expects array or object as arg

     - parameter node:    object to initialize with
     - parameter context: context to initialize in

     - throws: if mapping fails
     */
    public init(node: AnyObject, in context: Context = EmptyNode) throws {
        let array = node as? [AnyObject] ?? [node]
        try self.init(node: array, in: context)
    }

    /**
     Initializes set of convertibles with array of objects

     - parameter node:    array
     - parameter context: context to initialize in

     - throws: if mapping fails
     */
    public init(node: [AnyObject], in context: Context = EmptyNode) throws {
        let array = try node.map { try Element(node: $0, in: context) }
        self.init(array)
    }
}
#endif
