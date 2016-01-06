//
//  Map.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

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

extension KeyType : Equatable {
    var keyPath: String? {
        guard case let .KeyPath(keyPath) = self else { return nil }
        return keyPath
    }
    
    var key: String? {
        guard case let .Key(key) = self else { return nil }
        return key
    }
}

public func ==(lhs: KeyType, rhs: KeyType) -> Bool {
    return lhs.key == rhs.key || lhs.keyPath == rhs.keyPath
}
