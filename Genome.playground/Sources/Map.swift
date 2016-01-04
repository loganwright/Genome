//
//  Map.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

// MARK: Map

public enum KeyType {
    case KeyPath(String)
    case Key(String)
}

extension KeyType : CustomStringConvertible {
    public var description: String {
        switch self {
        case let .Key(key):
            return ".Key(\(key))"
        case let .KeyPath(keyPath):
            return ".KeyPath(\(keyPath))"
        }
    }
}

extension KeyType : StringLiteralConvertible {
    public typealias RawValue = StringLiteralType
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public typealias UnicodeScalarLiteralType = StringLiteralType
    
    // MARK: Initializers
    
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init?(rawValue: RawValue) {
        self.init(rawValue)
    }
    
    init(_ string: String) {
        // defaults to keypath
        self = .KeyPath(string)
    }
}

/// This class is designed to serve as an adaptor between the raw json and the values.  In this way we can interject behavior that assists in mapping between the two.
public final class Map {
    
    // MARK: Map Type
    
    /**
    The representative type of mapping operation
    
    - ToJson:   transforming the object into a json dictionary representation
    - FromJson: transforming a json dictionary representation into an object
    */
    public enum OperationType {
        case ToJson
        case FromJson
    }
    
    /// The type of operation for the current map
    public var type: OperationType = .FromJson
    
    /// If the mapping operation were converted to JSON (Type.ToJson)
    public private(set) var toJson: Json = .ObjectValue([:])
    
    /// The backing JSON being mapped
    public let json: Json
    
    /// The greater context in which the mapping takes place
    public let context: Json // TODO: Should probably be `Map`
    
    // MARK: Private
    
    /// The key to link from (for json)
    internal private(set) var linkFrom = ""
    
    /// The key to link to (array of objects in `context` at this key)
    internal private(set) var linkTo = ""
    
    /// The last key accessed -- Used to reverse JSON Operations
    internal private(set) var lastKey: KeyType = .KeyPath("")
    
    /// The last retrieved result.  Used in operators to set value
    internal private(set) var result: Json? {
        didSet {
            if let unwrapped = result where unwrapped.isNull {
                result = nil
            }
        }
    }
    
    // MARK: Initialization
    
    /**
    The designated initializer
    
    :param: json    the json that will be used in the mapping
    :param: context the context that will be used in the mapping
    
    :returns: an initialized map
    */
    public init(json: Json = .ObjectValue([:]), context: Json = .ObjectValue([:])) {
        self.json = json
        self.context = context
    }
    
    // MARK: Subscript
    
    /**
    Basic subscripting
    
    :param: keyPath the keypath to use when getting the value from the backing json
    
    :returns: returns an instance of self that can be passed to the mappable operator
    */
    public subscript(keyType: KeyType) -> Map {
        lastKey = keyType
        switch keyType {
        case let .Key(key):
            result = json[key]
        case let .KeyPath(keyPath):
            json[""]
            result = json.gnm_valueForKeyPath(keyPath)
        }
        return self
    }
    
    // MARK: To JSON
    
    /**
    Accept 'Any' type and convert for things like Int that don't conform to AnyObject, but can be put into Json Dict and pass a cast to 'AnyObject'
    
    :param: any the value to set to the json for the value of the last key
    */
    internal func setToLastKey(json: Json?) throws {
        print("Before Set: \(toJson)")
        guard let json = json else { return }
        switch lastKey {
        case let .Key(key):
            toJson[key] = json
        case let .KeyPath(keyPath):
            toJson.gnm_setValue(json, forKeyPath: keyPath)
        }
        print("After Set: \(toJson)")
        print("")
    }
}

extension Map {
    internal func setToLastKey<T : JSONConvertibleType>(any: T?) throws {
        print("Any: \(any)")
        print("AnyJson: \(try! any?.jsonRepresentation())")
        try setToLastKey(any?.jsonRepresentation())
    }
    
    internal func setToLastKey<T : JSONConvertibleType>(any: [T]?) throws {
        try setToLastKey(any?.jsonRepresentation())
    }
    
    internal func setToLastKey<T : JSONConvertibleType>(any: [[T]]?) throws {
        guard let any = any else { return }
        let json: [Json] = try any.map { innerArray in
            return try innerArray.jsonRepresentation()
        }
        try setToLastKey(Json.from(json))
    }
    
    internal func setToLastKey<T : JSONConvertibleType>(any: [String : T]?) throws {
        guard let any = any else { return }
        var json: [String : Json] = [:]
        try any.forEach { key, value in
            json[key] = try value.jsonRepresentation()
        }
        try setToLastKey(.from(json))
    }
    
    internal func setToLastKey<T : JSONConvertibleType>(any: [String : [T]]?) throws {
        guard let any = any else { return }
        var json: [String : Json] = [:]
        try any.forEach { key, value in
            json[key] = try value.jsonRepresentation()
        }
        try setToLastKey(.from(json))
    }
    
    internal func setToLastKey<T : JSONConvertibleType>(any: Set<T>?) throws {
        try setToLastKey(any?.jsonRepresentation())
    }
}

