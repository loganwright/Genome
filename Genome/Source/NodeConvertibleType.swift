//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: Constants

public let EmptyNode = Node.ObjectValue([:])

// MARK: Context

public protocol Context {}

extension Map : Context {}
extension Node : Context {}
extension Array : Context {}
extension Dictionary : Context {}

// MARK: NodeConvertibleType

public protocol NodeConvertibleType {
    static func newInstance(node: Node, context: Context) throws -> Self
    func nodeRepresentation() throws -> Node
}

// MARK: Node

extension Node : NodeConvertibleType {
    public static func newInstance(node: Node, context: Context = EmptyNode) -> Node {
        return node
    }
    
    public func nodeRepresentation() -> Node {
        return self
    }
}

// MARK: String

extension String : NodeConvertibleType {
    public func nodeRepresentation() throws -> Node {
        return .from(self)
    }
    
    public static func newInstance(node: Node, context: Context = EmptyNode) throws -> String {
        guard let string = node.stringValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        return string
    }
}

// MARK: Boolean

extension Bool : NodeConvertibleType {
    public func nodeRepresentation() throws -> Node {
        return .from(self)
    }
    
    public static func newInstance(node: Node, context: Context = EmptyNode) throws -> Bool {
        guard let bool = node.boolValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        return bool
    }
}

// MARK: UnsignedIntegerType

extension UInt : NodeConvertibleType {}
extension UInt8 : NodeConvertibleType {}
extension UInt16 : NodeConvertibleType {}
extension UInt32 : NodeConvertibleType {}
extension UInt64 : NodeConvertibleType {}

extension UnsignedIntegerType {
    public func nodeRepresentation() throws -> Node {
        let double = Double(UIntMax(self.toUIntMax()))
        return .from(double)
    }
    
    public static func newInstance(node: Node, context: Context = EmptyNode) throws -> Self {
        guard let int = node.uintValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        
        return self.init(int.toUIntMax())
    }
}

// MARK: SignedIntegerType

extension Int : NodeConvertibleType {}
extension Int8 : NodeConvertibleType {}
extension Int16 : NodeConvertibleType {}
extension Int32 : NodeConvertibleType {}
extension Int64 : NodeConvertibleType {}

extension SignedIntegerType {
    public func nodeRepresentation() throws -> Node {
        let double = Double(IntMax(self.toIntMax()))
        return .from(double)
    }
    
    public static func newInstance(node: Node, context: Context = EmptyNode) throws -> Self {
        guard let int = node.intValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        
        return self.init(int.toIntMax())
    }
}

// MARK: FloatingPointType

extension Float : NodeConvertibleFloatingPointType {
    public var doubleValue: Double {
        return Double(self)
    }
}

extension Double : NodeConvertibleFloatingPointType {
    public var doubleValue: Double {
        return Double(self)
    }
}

public protocol NodeConvertibleFloatingPointType : NodeConvertibleType {
    var doubleValue: Double { get }
    init(_ other: Double)
}

extension NodeConvertibleFloatingPointType {
    public func nodeRepresentation() throws -> Node {
        return .from(doubleValue)
    }
    
    public static func newInstance(node: Node, context: Context = EmptyNode) throws -> Self {
        guard let double = node.doubleValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        return self.init(double)
    }
}

// MARK: Convenience

extension Node {
    public init(_ dictionary: [String : NodeConvertibleType]) throws{
        self = try Node.from(dictionary)
    }
    
    public static func from(dictionary: [String : NodeConvertibleType]) throws -> Node {
        var mutable: [String : Node] = [:]
        try dictionary.forEach { key, value in
            mutable[key] = try value.nodeRepresentation()
        }
        
        return .from(mutable)
    }
}
