//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: Constants

public let EmptyNode = Node.object([:])

// MARK: Context

public protocol Context {}

extension Map : Context {}
extension Node : Context {}
extension Array : Context {}
extension Dictionary : Context {}

// MARK: NodeConvertible

public protocol NodeConvertible {
    init(with node: Node, in context: Context) throws
    func makeNode() throws -> Node
}

extension NodeConvertible {
    public init(with node: Node) throws {
        try self.init(with: node, in: node)
    }
}

// MARK: Node

extension Node: NodeConvertible { // Can conform to both if non-throwing implementations
    public init(with node: Node, in context: Context) {
        self = node
    }
    
    public func makeNode() -> Node {
        return self
    }
}

// MARK: String

extension String: NodeConvertible {
    public func makeNode() throws -> Node {
        return Node(self)
    }
    
    public init(with node: Node, in context: Context) throws {
        self = try self.dynamicType.makeWith(node: node, context: context)
    }
    
    private static func makeWith(node: Node, context: Context) throws -> String {
        guard let string = node.stringValue else {
            throw log(.UnableToConvert(node: node, to: "\(self)"))
        }
        return string
    }
}

// MARK: Boolean

extension Bool: NodeConvertible {
    public func makeNode() throws -> Node {
        return Node(self)
    }
    
    public init(with node: Node, in context: Context) throws {
        self = try self.dynamicType.makeWith(node: node, context: context)
    }
    
    private static func makeWith(node: Node, context: Context) throws -> Bool {
        guard let bool = node.boolValue else {
            throw log(.UnableToConvert(node: node, to: "\(self)"))
        }
        return bool
    }
}

// MARK: UnsignedInteger

extension UInt: NodeConvertible {}
extension UInt8: NodeConvertible {}
extension UInt16: NodeConvertible {}
extension UInt32: NodeConvertible {}
extension UInt64: NodeConvertible {}

extension UnsignedInteger {
    public func makeNode() throws -> Node {
        let double = Double(UIntMax(self.toUIntMax()))
        return Node(double)
    }
    
    public init(with node: Node, in context: Context) throws {
        self = try Self.makeWith(node: node, context: context)
    }
    
    private static func makeWith(node: Node, context: Context) throws -> Self {
        guard let int = node.uintValue else {
            throw log(.UnableToConvert(node: node, to: "\(self)"))
        }
        
        return self.init(int.toUIntMax())
    }
}

// MARK: SignedInteger

extension Int: NodeConvertible {}
extension Int8: NodeConvertible {}
extension Int16: NodeConvertible {}
extension Int32: NodeConvertible {}
extension Int64: NodeConvertible {}

extension SignedInteger {
    public func makeNode() throws -> Node {
        let double = Double(IntMax(self.toIntMax()))
        return Node(double)
    }
    
    public init(with node: Node, in context: Context) throws {
        self = try Self.makeWith(node: node, context: context)
    }
    
    private static func makeWith(node: Node, context: Context) throws -> Self {
        guard let int = node.intValue else {
            throw log(.UnableToConvert(node: node, to: "\(Self.self)"))
        }
        
        return self.init(int.toIntMax())
    }
}

// MARK: FloatingPoint

extension Float: NodeConvertibleFloatingPointType {
    public var doubleValue: Double {
        return Double(self)
    }
}

extension Double: NodeConvertibleFloatingPointType {
    public var doubleValue: Double {
        return Double(self)
    }
}

public protocol NodeConvertibleFloatingPointType: NodeConvertible {
    var doubleValue: Double { get }
    init(_ other: Double)
}

extension NodeConvertibleFloatingPointType {
    public func makeNode() throws -> Node {
        return Node(doubleValue)
    }
    
    public init(with node: Node, in context: Context) throws {
        self = try Self.makeWith(node: node, context: context)
    }
    
    private static func makeWith(node: Node, context: Context) throws -> Self {
        guard let double = node.doubleValue else {
            throw log(.UnableToConvert(node: node, to: "\(Self.self)"))
        }
        return self.init(double)
    }
}

// MARK: Convenience

extension Node {
    public init(_ dictionary: [String : NodeConvertible]) throws {
        var mutable: [String : Node] = [:]
        try dictionary.forEach { key, value in
            mutable[key] = try value.makeNode()
        }
        self = .object(mutable)
    }
}
