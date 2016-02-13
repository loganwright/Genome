//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

/**
Genome automatically uses keypath, which means given the following:

[ 
    "one" : [
        "two" : "hello"
    ]
]

If you pass a key "one.two", the library will automatically fetch "hello" by default.

If however you have the following:

[
    "one.two" : "hello"
]

To access the value at "one.two", use `map[.Key("one.two")]` to assert that it is not key path components.



- KeyPath: default
- Key:     used for keys w/ '.'
*/
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
    
    public init(_ string: String) {
        // defaults to keypath
        self = .KeyPath(string)
    }
}

extension KeyType : Hashable {
    public var hashValue: Int {
        let underlyingValue = keyPath ?? key
        return "KeyType:\(underlyingValue)".hashValue
    }
}

extension KeyType : Equatable {
    public var keyPath: String? {
        guard case let .KeyPath(keyPath) = self else { return nil }
        return keyPath
    }
    
    public var key: String? {
        guard case let .Key(key) = self else { return nil }
        return key
    }
}

public func ==(lhs: KeyType, rhs: KeyType) -> Bool {
    return lhs.key == rhs.key || lhs.keyPath == rhs.keyPath
}
