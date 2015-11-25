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
    public private(set) var toJson: JSON = [:]
    
    /// The backing JSON being mapped
    public let json: JSON
    
    /// The greater context in which the mapping takes place
    public let context: JSON
    
    // MARK: Private
    
    /// The key to link from (for json)
    internal private(set) var linkFrom = ""
    
    /// The key to link to (array of objects in `context` at this key)
    internal private(set) var linkTo = ""
    
    /// The last key accessed -- Used to reverse JSON Operations
    internal private(set) var lastKey: KeyType = .KeyPath("")
    
    /// The last retrieved result.  Used in operators to set value
    internal private(set) var result: AnyObject? {
        didSet {
            /*
            This is a temporary fix for the issue of receiving NSNull in JSON.  I want this library to be platform agnostic which means I can't do a check using `is NSNull`. 
            */
            if let unwrapped = result where "\(unwrapped.dynamicType)" == "NSNull" {
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
    public init(json: JSON = [:], context: JSON = [:]) {
        self.json = json
        self.context = context
    }
    
    // MARK: Subscript
    
    /**
    Basic subscripting
    
    :param: keyPath the keypath to use when getting the value from the backing json
    
    :returns: returns an instance of self that can be passed to the mappable operator
    */
    public subscript(keyPath: String) -> Map {
        return self[.KeyPath(keyPath)]
    }
    
    public subscript(keyType: KeyType) -> Map {
        lastKey = keyType
        switch keyType {
        case let .Key(key):
            result = json[key]
        case let .KeyPath(keyPath):
            result = json.gnm_valueForKeyPath(keyPath)
        }
        return self
    }
    
    // MARK: To JSON
    
    /**
    Accept 'Any' type and convert for things like Int that don't conform to AnyObject, but can be put into Json Dict and pass a cast to 'AnyObject'
    
    :param: any the value to set to the json for the value of the last key
    */
    internal func setToLastKey<T>(any: T?) throws {
        if let a = any as? AnyObject {
            switch lastKey {
            case let .Key(key):
                toJson[key] = a
            case let .KeyPath(keyPath):
                toJson.gnm_setValue(a, forKeyPath: keyPath)
            }
        } else if any != nil {
            let message = "Unable to convert: \(any!) forKeyPath: \(lastKey) to JSON because type: \(any!.dynamicType) can't be cast to type AnyObject"
            let error = MappingError.UnableToMap(message)
            throw logError(error)
        }
    }
    
    internal func setToLastKey<T : MappableObject>(any: T?) throws {
        try setToLastKey(any?.jsonRepresentation())
    }
    
    internal func setToLastKey<T : MappableObject>(any: [T]?) throws {
        try setToLastKey(any?.jsonRepresentation())
    }
    
    internal func setToLastKey<T : MappableObject>(any: [[T]]?) throws {
        var json: [[JSON]]?
        if let any = any {
            json = []
            for array in any {
                json!.append(try array.jsonRepresentation())
            }
        }
        try setToLastKey(json)
    }
    
    internal func setToLastKey<T : MappableObject>(any: [String : T]?) throws {
        var json: [String : JSON]?
        if let any = any {
            json = [:]
            for (key, value) in any {
                json![key] = try value.jsonRepresentation()
            }
        }
        try setToLastKey(json)
    }
    
    internal func setToLastKey<T : MappableObject>(any: [String : [T]]?) throws {
        var json: [String : [JSON]]?
        if let any = any {
            json = [:]
            for (key, value) in any {
                json![key] = try value.jsonRepresentation()
            }
        }
        try setToLastKey(json)
    }
    
    internal func setToLastKey<T : MappableObject>(any: Set<T>?) throws {
        try setToLastKey(any?.jsonRepresentation())
    }
}
 