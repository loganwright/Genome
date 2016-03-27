//
//  Json.swift
//  JsonSerializer
//
//  Created by Fuji Goro on 2014/09/15.
//  Copyright (c) 2014 Fuji Goro. All rights reserved.
//

public enum TypeEnforcingLevel {
    case strict
    case fuzzy
    
    public var isStrict: Bool {
        return self == .strict
    }
    
    public var isFuzzy: Bool {
        return self == .fuzzy
    }
}

public var TypeEnforcing: TypeEnforcingLevel = .strict

public enum Node {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array([Node])
    case object([String:Node])
}

// MARK: Initialization

extension Node {
    public init(_ value: Bool) {
        self = .bool(value)
    }
    
    public init(_ value: Double) {
        self = .number(value)
    }
    
    public init(_ value: String) {
        self = .string(value)
    }
    
    public init(_ value: [String : Node]) {
        self = .object(value)
    }

    #if swift(>=3.0)
    public init<T: Integer>(_ value: T) {
        self = .number(Double(value.toIntMax()))
    }
    
    public init<T : Sequence where T.Iterator.Element == Node>(_ value: T) {
        let array = [Node](value)
        self = .array(array)
    }
    
    public init<T : Sequence where T.Iterator.Element == (key: String, value: Node)>(_ seq: T) {
        var obj: [String : Node] = [:]
        seq.forEach { key, val in
            obj[key] = val
        }
        self = .object(obj)
    }
    #else
    public init<T: IntegerType>(_ value: T) {
        self = .number(Double(value.toIntMax()))
    }
    
    public init<T : SequenceType where T.Generator.Element == Node>(_ value: T) {
        let array = [Node](value)
        self = .array(array)
    }
    
    public init<T : SequenceType where T.Generator.Element == (key: String, value: Node)>(_ seq: T) {
        var obj: [String : Node] = [:]
        seq.forEach { key, val in
            obj[key] = val
        }
        self = .object(obj)
    }
    #endif
}

// MARK: Convenience

extension Node {
    public var isNull: Bool {
        // Type enforcing level doesn't really apply here
        guard case .null = self else { return false }
        return true
    }
}

extension Node {
    public var boolValue: Bool? {
        switch TypeEnforcing {
        case .strict:
            return strictBoolValue
        case .fuzzy:
            return fuzzyBoolValue
        }
    }
    
    public var strictBoolValue: Bool? {
        if case let .bool(bool) = self {
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
    
    public var fuzzyBoolValue: Bool? {
        if let strict = strictBoolValue {
            return strict
        } else if let n = strictNumberValue {
            return n > 0
        } else if let s = strictStringValue {
            return Bool(s)
        } else {
            return nil
        }
    }
}

extension Node {
    public var numberValue: Double? {
        switch TypeEnforcing {
        case .strict:
            return strictNumberValue
        case .fuzzy:
            return fuzzyNumberValue
        }
    }
    
    public var strictNumberValue: Double? {
        guard case let .number(number) = self else {
            return nil
        }
        
        return number
    }
    
    public var fuzzyNumberValue: Double? {
        if let n = strictNumberValue {
            return n
        } else if let s = strictStringValue {
            return Double(s)
        } else if let b = strictBoolValue {
            return b ? 1 : 0
        } else {
            return nil
        }
    }
    
    public var floatValue: Float? {
        return numberValue.flatMap(Float.init)
    }
    
    public var doubleValue: Double? {
        return numberValue
    }
}

extension Node {
    public var intValue: Int? {
        switch TypeEnforcing {
        case .strict:
            return strictIntValue
        case .fuzzy:
            return fuzzyIntValue
        }
    }
    
    public var strictIntValue: Int? {
        guard let double = numberValue where double % 1 == 0 else {
            return nil
        }
        
        return Int(double)
    }
    
    public var fuzzyIntValue: Int? {
        if let i = strictIntValue {
            return i
        } else if let s = strictStringValue {
            return Int(s)
        } else if let b = strictBoolValue {
            return b ? 1 : 0
        } else {
            return nil
        }
    }
}

extension Node {
    public var uintValue: UInt? {
        switch TypeEnforcing {
        case .strict:
            return strictUIntValue
        case .fuzzy:
            return fuzzyUIntValue
        }
    }
    
    public var strictUIntValue: UInt? {
        guard let intValue = strictIntValue where intValue >= 0 else { return nil }
        return UInt(intValue)
    }
    
    public var fuzzyUIntValue: UInt? {
        if let ui = strictUIntValue {
            return ui
        } else if let i = strictIntValue {
            return i > 0 ? UInt(i) : 0
        } else if let s = strictStringValue {
            return UInt(s)
        } else if let b = strictBoolValue {
            return b ? 1 : 0
        } else {
            return nil
        }
    }
}

extension Node {
    public var stringValue: String? {
        switch TypeEnforcing {
        case .strict:
            return strictStringValue
        case .fuzzy:
            return fuzzyStringValue
        }
    }
    
    public var strictStringValue: String? {
        guard case let .string(string) = self else {
            return nil
        }
        
        return string
    }
    
    public var fuzzyStringValue: String? {
        if let s = strictStringValue {
            return s
        } else if let i = strictIntValue { // int first so if it's an int, we omit `1.0` in preference of `1`
            return i.description
        } else if let n = strictNumberValue {
            return n.description
        } else if let b = strictBoolValue {
            return b.description
        } else {
            return nil
        }
    }
}

extension Node {
    public var arrayValue: [Node]? {
        switch TypeEnforcing {
        case .strict:
            return strictArrayValue
        case .fuzzy:
            return fuzzyArrayValue
        }
    }
    
    public var strictArrayValue: [Node]? {
        guard case let .array(array) = self else { return nil }
        return array
    }
    
    public var fuzzyArrayValue: [Node]? {
        if let a = strictArrayValue {
            return a
        } else if let s = strictStringValue {
            return s.characters
                .split { $0 == "," }
                .map(String.init)
                .map { Node($0) }
        } else {
            return nil
        }
    }
}

extension Node {
    public var objectValue: [String : Node]? {
        switch TypeEnforcing {
        case .strict:
            return strictObjectValue
        case .fuzzy:
            return fuzzyObjectValue
        }

    }
    
    public var strictObjectValue: [String : Node]? {
        guard case let .object(object) = self else { return nil }
        return object
    }
    
    public var fuzzyObjectValue: [String : Node]? {
        // I'm not sure if there's anything else that should map to an object.
        // Possibly string w/ `&` or something,
        // the issue is if there's no `&`, should it return empty dictionary?
        return strictObjectValue
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
            self = .array(mutable)
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
        case .null:
            return "NULL"
        case let .bool(boolean):
            return boolean ? "true" : "false"
        case let .string(string):
            return string
        case let .number(number):
            return number.description
        case let .array(array):
            return array.description
        case let .object(object):
            return object.description
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .null:
            return "NULL".debugDescription
        case let .bool(boolean):
            return boolean ? "true".debugDescription : "false".debugDescription
        case let .string(string):
            return string.debugDescription
        case let .number(number):
            return number.description
        case let .array(array):
            return array.debugDescription
        case let .object(object):
            return object.debugDescription
        }
    }
}

extension Node: Equatable {}

public func ==(lhs: Node, rhs: Node) -> Bool {
    switch lhs {
    case .null:
        return rhs.isNull
    case .bool(let lhsValue):
        guard let rhsValue = rhs.boolValue else { return false }
        return lhsValue == rhsValue
    case .string(let lhsValue):
        guard let rhsValue = rhs.stringValue else { return false }
        return lhsValue == rhsValue
    case .number(let lhsValue):
        guard let rhsValue = rhs.doubleValue else { return false }
        return lhsValue == rhsValue
    case .array(let lhsValue):
        guard let rhsValue = rhs.arrayValue else { return false }
        return lhsValue == rhsValue
    case .object(let lhsValue):
        guard let rhsValue = rhs.objectValue else { return false }
        return lhsValue == rhsValue
    }
}

// MARK: Literal Convertibles

extension Node: NilLiteralConvertible {
    public init(nilLiteral value: Void) {
        self = .null
    }
}

extension Node: BooleanLiteralConvertible {
    public init(booleanLiteral value: BooleanLiteralType) {
        self = .bool(value)
    }
}

extension Node: IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .number(Double(value))
    }
}

extension Node: FloatLiteralConvertible {
    public init(floatLiteral value: FloatLiteralType) {
        self = .number(Double(value))
    }
}

extension Node: StringLiteralConvertible {
    public typealias UnicodeScalarLiteralType = String
    public typealias ExtendedGraphemeClusterLiteralType = String
    
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self = .string(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterType) {
        self = .string(value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }
}

extension Node: ArrayLiteralConvertible {
    public init(arrayLiteral elements: Node...) {
        self = .array(elements)
    }
}

extension Node: DictionaryLiteralConvertible {
    public init(dictionaryLiteral elements: (String, Node)...) {
        var object = [String : Node](minimumCapacity: elements.count)
        elements.forEach { key, value in
            object[key] = value
        }
        self = .object(object)
    }
}

// MARK: HELPERS


// TODO: Break Out
extension Bool {
    /**
     This function seeks to replicate the expected behavior of `var boolValue: Bool` on `NSString`.  Any variant of `yes`, `y`, `true`, `t`, or any numerical value greater than 0 will be considered `true`
     */
    public init(_ string: String) {
        let cleaned = string
            .lowercased()
            .characters
            .first ?? "n"
        
        switch cleaned {
        case "t", "y", "1":
            self = true
        default:
            if let int = Int(String(cleaned)) where int > 0 {
                self = true
            } else {
                self = false
            }
            
        }
    }
}

//extension String {
//    /**
//     Parses `key=value` pair data separated by `&`.
//     
//     - returns: String dictionary of parsed data
//     */
//    internal func keyValuePairs() -> [String: String]? {
//        var data: [String: String] = [:]
//        
//        for pair in self.split("&") {
//            let tokens = pair.split("=", maxSplits: 1)
//            
//            if
//                let name = tokens.first,
//                let value = tokens.last,
//                let parsedName = try? String(percentEncoded: name) {
//                data[parsedName] = try? String(percentEncoded: value)
//            }
//        }
//        
//        return data.isEmpty ? nil : data
//    }
//}
//
//// FROM: Zewo - String
//
//extension String {
//    public func split(separator: Character, maxSplits: Int = .max, omittingEmptySubsequences: Bool = true) -> [String] {
//        return characters.split(separator: separator, maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences).map(String.init)
//    }
//    
//    public init(percentEncoded: String) throws {
//        struct Error: ErrorProtocol, CustomStringConvertible {
//            let description: String
//        }
//        
//        let spaceCharacter: UInt8 = 32
//        let percentCharacter: UInt8 = 37
//        let plusCharacter: UInt8 = 43
//        
//        var encodedBytes: [UInt8] = [] + percentEncoded.utf8
//        var decodedBytes: [UInt8] = []
//        var i = 0
//        
//        while i < encodedBytes.count {
//            let currentCharacter = encodedBytes[i]
//            
//            switch currentCharacter {
//            case percentCharacter:
//                let unicodeA = UnicodeScalar(encodedBytes[i + 1])
//                let unicodeB = UnicodeScalar(encodedBytes[i + 2])
//                
//                let hexString = "\(unicodeA)\(unicodeB)"
//                
//                
//                
//                guard let character = Int(hexString, radix: 16) else {
//                    throw Error(description: "Invalid string")
//                }
//                
//                decodedBytes.append(UInt8(character))
//                i += 3
//                
//            case plusCharacter:
//                decodedBytes.append(spaceCharacter)
//                i += 1
//                
//            default:
//                decodedBytes.append(currentCharacter)
//                i += 1
//            }
//        }
//        
//        var string = ""
//        var decoder = UTF8()
//        var iterator = decodedBytes.makeIterator()
//        var finished = false
//        
//        while !finished {
//            let decodingResult = decoder.decode(&iterator)
//            switch decodingResult {
//            case .scalarValue(let char): string.append(char)
//            case .emptyInput: finished = true
//            case .error:
//                throw Error(description: "UTF-8 decoding failed")
//            }
//        }
//        
//        self.init(string)
//    }
//}