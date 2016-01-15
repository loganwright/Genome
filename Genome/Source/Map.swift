//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

import PureJsonSerializer

// MARK: Map

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
    public let type: OperationType
    
    /// If the mapping operation were converted to Json (Type.ToJson)
    public private(set) var toJson: Json = .ObjectValue([:])
    
    /// The backing Json being mapped
    public let json: Json
    
    /// The greater context in which the mapping takes place
    public let context: Context
    
    // MARK: Private
    
    /// The last key accessed -- Used to reverse Json Operations
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
    public init(json: Json, context: Context = EmptyJson) {
        self.json = json
        self.context = context
        self.type = .FromJson
    }
    
    public init() {
        self.json = [:]
        self.context = EmptyJson
        self.type = .ToJson
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
            result = json.gnm_valueForKeyPath(keyPath)
        }
        return self
    }
    
    // MARK: To Json
    
    /**
    Accept 'Any' type and convert for things like Int that don't conform to AnyObject, but can be put into Json Dict and pass a cast to 'AnyObject'
    
    :param: any the value to set to the json for the value of the last key
    */
    internal func setToLastKey(json: Json?) throws {
        guard let json = json else { return }
        switch lastKey {
        case let .Key(key):
            toJson[key] = json
        case let .KeyPath(keyPath):
            toJson.gnm_setValue(json, forKeyPath: keyPath)
        }
    }
}

extension Map {
    internal func setToLastKey<T : JsonConvertibleType>(any: T?) throws {
        try setToLastKey(any?.jsonRepresentation())
    }
    
    internal func setToLastKey<T : JsonConvertibleType>(any: [T]?) throws {
        try setToLastKey(any?.jsonRepresentation())
    }
    
    internal func setToLastKey<T : JsonConvertibleType>(any: [[T]]?) throws {
        guard let any = any else { return }
        let json: [Json] = try any.map { innerArray in
            return try innerArray.jsonRepresentation()
        }
        try setToLastKey(Json.from(json))
    }
    
    internal func setToLastKey<T : JsonConvertibleType>(any: [String : T]?) throws {
        guard let any = any else { return }
        var json: [String : Json] = [:]
        try any.forEach { key, value in
            json[key] = try value.jsonRepresentation()
        }
        try setToLastKey(.from(json))
    }
    
    internal func setToLastKey<T : JsonConvertibleType>(any: [String : [T]]?) throws {
        guard let any = any else { return }
        var json: [String : Json] = [:]
        try any.forEach { key, value in
            json[key] = try value.jsonRepresentation()
        }
        try setToLastKey(.from(json))
    }
    
    internal func setToLastKey<T : JsonConvertibleType>(any: Set<T>?) throws {
        try setToLastKey(any?.jsonRepresentation())
    }
}

