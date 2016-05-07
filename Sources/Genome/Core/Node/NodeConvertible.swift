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

/**
 Sometimes convertible operations require a greater context beyond
 just a Node.
 
 Any object can conform to Context and be included in initialization
 */
public protocol Context {}

extension Node : Context {}
extension Array : Context {}
extension Dictionary : Context {}

// MARK: NodeConvertible

/**
 The underlying protocol used for all conversions. 
 
 This is the base of all Genome, where both sides of data are NodeConvertible.
 
 The Mapped object, as well as the Backing data both conform. 
 Any NodeConvertible can be turned into any other NodeConvertible type
 
 Json => Node => Object
 */
public protocol NodeConvertible {

    /**
     Initialiize the convertible with a node within a context.
     
     Context is an empty protocol to which any type can conform.
     This allows flexibility. for objects that might require access
     to a context outside of the json ecosystem
     */
    init(with node: Node, in context: Context) throws
    
    /**
     Turn the convertible back into a node

     - throws: if convertible can not create a Node

     - returns: a node if possible
     */
    func toNode() throws -> Node
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
    
    public func toNode() -> Node {
        return self
    }
}

// MARK: String

extension String: NodeConvertible {
    public func toNode() throws -> Node {
        return Node(self)
    }
    
    public init(with node: Node, in context: Context) throws {
        guard let string = node.string else {
            throw ErrorFactory.unableToConvert(node, to: self.dynamicType)
        }
        self = string
    }
}

// MARK: Boolean

extension Bool: NodeConvertible {
    public func toNode() throws -> Node {
        return Node(self)
    }
    
    public init(with node: Node, in context: Context) throws {
        guard let bool = node.bool else {
            throw ErrorFactory.unableToConvert(node, to: self.dynamicType)
        }
        self = bool
    }
}

// MARK: UnsignedInteger

extension UInt: NodeConvertible {}
extension UInt8: NodeConvertible {}
extension UInt16: NodeConvertible {}
extension UInt32: NodeConvertible {}
extension UInt64: NodeConvertible {}

extension UnsignedInteger {
    public func toNode() throws -> Node {
        let double = Double(UIntMax(self.toUIntMax()))
        return Node(double)
    }
    
    public init(with node: Node, in context: Context) throws {
        guard let int = node.uint else {
            throw ErrorFactory.unableToConvert(node, to: Self.self)
        }

        self.init(int.toUIntMax())
    }
}

// MARK: SignedInteger

extension Int: NodeConvertible {}
extension Int8: NodeConvertible {}
extension Int16: NodeConvertible {}
extension Int32: NodeConvertible {}
extension Int64: NodeConvertible {}

extension SignedInteger {
    public func toNode() throws -> Node {
        let double = Double(IntMax(self.toIntMax()))
        return Node(double)
    }
    
    public init(with node: Node, in context: Context) throws {
        guard let int = node.int else {
            throw ErrorFactory.unableToConvert(node, to: Self.self)
        }

        self.init(int.toIntMax())
    }
}

// MARK: FloatingPoint

public protocol NodeConvertibleFloatingPointType: NodeConvertible {
    var doubleValue: Double { get }
    init(_ other: Double)
}

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

extension NodeConvertibleFloatingPointType {
    public func toNode() throws -> Node {
        return Node(doubleValue)
    }
    
    public init(with node: Node, in context: Context) throws {
        guard let double = node.double else {
            throw ErrorFactory.unableToConvert(node, to: Self.self)
        }
        self.init(double)
    }
}

// MARK: Convenience

extension Node {
    public init(_ dictionary: [String : NodeConvertible]) throws {
        var mutable: [String : Node] = [:]
        try dictionary.forEach { key, value in
            mutable[key] = try value.toNode()
        }
        self = .object(mutable)
    }
}

extension Node {
    public init(_ array: [NodeConvertible]) throws {
        var mutable: [Node] = []
        mutable = try array.map { try $0.toNode() }
        self = .array(mutable)
    }
}
