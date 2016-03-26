//
//  Json.swift
//  JsonSerializer
//
//  Created by Fuji Goro on 2014/09/15.
//  Copyright (c) 2014 Fuji Goro. All rights reserved.
//

public enum Node {
    case NullValue
    case BooleanValue(Bool)
    case NumberValue(Double)
    case StringValue(String)
    case ArrayValue([Node])
    case ObjectValue([String:Node])
}

// MARK: Initialization

extension Node {
    public init(_ value: Bool) {
        self = .BooleanValue(value)
    }
    
    public init(_ value: Double) {
        self = .NumberValue(value)
    }
    
    public init(_ value: String) {
        self = .StringValue(value)
    }
    
    public init(_ value: [String : Node]) {
        self = .ObjectValue(value)
    }

    #if swift(>=3.0)
    public init<T: Integer>(_ value: T) {
        self = .NumberValue(Double(value.toIntMax()))
    }
    
    public init<T : Sequence where T.Iterator.Element == Node>(_ value: T) {
        let array = [Node](value)
        self = .ArrayValue(array)
    }
    
    public init<T : Sequence where T.Iterator.Element == (key: String, value: Node)>(_ seq: T) {
        var obj: [String : Node] = [:]
        seq.forEach { key, val in
            obj[key] = val
        }
        self = .ObjectValue(obj)
    }
    #else
    public init<T: IntegerType>(_ value: T) {
        self = .NumberValue(Double(value.toIntMax()))
    }
    
    public init<T : SequenceType where T.Generator.Element == Node>(_ value: T) {
        let array = [Node](value)
        self = .ArrayValue(array)
    }
    
    public init<T : SequenceType where T.Generator.Element == (key: String, value: Node)>(_ seq: T) {
        var obj: [String : Node] = [:]
        seq.forEach { key, val in
            obj[key] = val
        }
        self = .ObjectValue(obj)
    }
    #endif
}

// MARK: Convenience

extension Node {
    public var isNull: Bool {
        guard case .NullValue = self else { return false }
        return true
    }
    
    public var boolValue: Bool? {
        if case let .BooleanValue(bool) = self {
            return bool
        } else if let integer = intValue where integer == 1 || integer == 0 {
            // When converting from foundation type `[String : AnyObject]`, something that I see as important,
            // it's not possible to distinguish between 'bool', 'double', and 'int'.
            // Because of this, if we have an integer that is 0 or 1, and a user is requesting a boolean val,
            // it's fairly likely this is their desired result.
            return integer == 1
        } else {
            return nil
        }
    }
    
    public var numberValue: Double? {
        guard case let .NumberValue(number) = self else {
            return nil
        }
        
        return number
    }
    
    public var floatValue: Float? {
        return numberValue.flatMap(Float.init)
    }
    
    public var doubleValue: Double? {
        return numberValue
    }
    
    public var intValue: Int? {
        guard let double = numberValue where double % 1 == 0 else {
            return nil
        }
        
        return Int(double)
    }
    
    public var uintValue: UInt? {
        guard let intValue = intValue where intValue >= 0 else { return nil }
        return UInt(intValue)
    }
    
    public var stringValue: String? {
        guard case let .StringValue(string) = self else {
            return nil
        }
        
        return string
    }
    
    public var arrayValue: [Node]? {
        guard case let .ArrayValue(array) = self else { return nil }
        return array
    }
    
    public var objectValue: [String : Node]? {
        guard case let .ObjectValue(object) = self else { return nil }
        return object
    }
}

extension Node {
    public subscript(index: Int) -> Node? {
        get {
            guard let array = arrayValue where index < array.count else { return nil }
            return array[index]
        }
        set {
            guard let array = arrayValue where index < array.count else { return }
            var mutable = array
            if let new = newValue {
                mutable[index] = new
            } else {
                #if swift(>=3.0)
                    mutable.remove(at: index)
                #else
                    mutable.removeAtIndex(index)
                #endif
            }
            self = .ArrayValue(mutable)
        }
    }
    
    public subscript(key: String) -> Node? {
        get {
            guard let dict = objectValue else { return nil }
            return dict[key]
        }
        set {
            guard let object = objectValue else { fatalError("Unable to set string subscript on non-object type!") }
            var mutableObject = object
            mutableObject[key] = newValue
            self = Node(mutableObject)
        }
    }
}

extension Node: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .NullValue:
            return "NULL"
        case let .BooleanValue(boolean):
            return boolean ? "true" : "false"
        case let .StringValue(string):
            return string
        case let .NumberValue(number):
            return number.description
        case let .ArrayValue(array):
            return array.description
        case let .ObjectValue(object):
            return object.description
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .NullValue:
            return "NULL".debugDescription
        case let .BooleanValue(boolean):
            return boolean ? "true".debugDescription : "false".debugDescription
        case let .StringValue(string):
            return string.debugDescription
        case let .NumberValue(number):
            return number.description
        case let .ArrayValue(array):
            return array.debugDescription
        case let .ObjectValue(object):
            return object.debugDescription
        }
    }
}

extension Node: Equatable {}

public func ==(lhs: Node, rhs: Node) -> Bool {
    switch lhs {
    case .NullValue:
        return rhs.isNull
    case .BooleanValue(let lhsValue):
        guard let rhsValue = rhs.boolValue else { return false }
        return lhsValue == rhsValue
    case .StringValue(let lhsValue):
        guard let rhsValue = rhs.stringValue else { return false }
        return lhsValue == rhsValue
    case .NumberValue(let lhsValue):
        guard let rhsValue = rhs.doubleValue else { return false }
        return lhsValue == rhsValue
    case .ArrayValue(let lhsValue):
        guard let rhsValue = rhs.arrayValue else { return false }
        return lhsValue == rhsValue
    case .ObjectValue(let lhsValue):
        guard let rhsValue = rhs.objectValue else { return false }
        return lhsValue == rhsValue
    }
}

// MARK: Literal Convertibles

extension Node: NilLiteralConvertible {
    public init(nilLiteral value: Void) {
        self = .NullValue
    }
}

extension Node: BooleanLiteralConvertible {
    public init(booleanLiteral value: BooleanLiteralType) {
        self = .BooleanValue(value)
    }
}

extension Node: IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .NumberValue(Double(value))
    }
}

extension Node: FloatLiteralConvertible {
    public init(floatLiteral value: FloatLiteralType) {
        self = .NumberValue(Double(value))
    }
}

extension Node: StringLiteralConvertible {
    public typealias UnicodeScalarLiteralType = String
    public typealias ExtendedGraphemeClusterLiteralType = String
    
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self = .StringValue(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterType) {
        self = .StringValue(value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self = .StringValue(value)
    }
}

extension Node: ArrayLiteralConvertible {
    public init(arrayLiteral elements: Node...) {
        self = .ArrayValue(elements)
    }
}

extension Node: DictionaryLiteralConvertible {
    public init(dictionaryLiteral elements: (String, Node)...) {
        var object = [String : Node](minimumCapacity: elements.count)
        elements.forEach { key, value in
            object[key] = value
        }
        self = .ObjectValue(object)
    }
}
