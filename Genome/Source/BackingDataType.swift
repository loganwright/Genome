//
//  BackingDataType.swift
//  Genome
//
//  Created by Logan Wright on 2/10/16.
//  Copyright © 2016 lowriDevs. All rights reserved.
//

import Foundation

extension Node: BackingDataType {
    public init(_ node: Node) {
        self = node
    }
}

public protocol BackingDataType {
    var isNull: Bool { get }
    var boolValue: Bool? { get }
    var doubleValue: Double? { get }
    var stringValue: String? { get }
    var arrayValue: [Self]? { get }
    var objectValue: [String : Self]? { get }
    
    init(_ node: Node)
}

extension BackingDataType {
    public var floatValue: Float? {
        guard let double = doubleValue else { return nil }
        return Float(double)
    }
    
    public var intValue: Int? {
        guard let double = doubleValue where double % 1 == 0 else {
            return nil
        }
        
        return Int(double)
    }
    
    public var uintValue: UInt? {
        guard let int = intValue where int >= 0 else { return nil }
        return UInt(int)
    }
}

extension Node {
    public init<T: BackingDataType>(_ data: T) {
        if let string = data.stringValue {
            self = .StringValue(string)
        } else if let bool = data.boolValue {
            self = .BooleanValue(bool)
        } else if let number = data.doubleValue {
            self = .NumberValue(number)
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

extension Node {
    public func dataRepresentation<T: BackingDataType>() -> T {
        return T.init(self)
    }
}


extension MappableObject {
    public init<T: BackingDataType>(node: T, context: [String : AnyObject] = [:]) throws {
        let safeNode = Node(node)
        let safeContext = Node(context)
        try self.init(node: safeNode, context: safeContext)
    }
    
    public init<T: BackingDataType>(node: [String : T], context: [String : AnyObject] = [:]) throws {
        var mapped: [String : Node] = [:]
        node.forEach { key, value in
            mapped[key] = Node(value)
        }
        try self.init(node: node, context: context)
    }
}
