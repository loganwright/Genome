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
    init(node: Node, context: Context) throws
    func toNode() throws -> Node
}

extension NodeConvertibleType {
    public init(node: Node) throws {
        try self.init(node: node, context: node)
    }
    
    public static func makeWith(node: Node, context: Context = EmptyNode) throws -> Self {
        return try self.init(node: node, context: context)
    }
}

// MARK: Node

extension Node: NodeConvertibleType { // Can conform to both if non-throwing implementations
    public init(node: Node, context: Context) {
        self = node
    }
    
    public func toNode() -> Node {
        return self
    }
}

// MARK: String

extension String: NodeConvertibleType {
    public func toNode() throws -> Node {
        return Node(self)
    }
    
    public init(node: Node, context: Context) throws {
        self = try self.dynamicType.makeWith(node, context: context)
    }
    
    private static func makeWith(node: Node, context: Context) throws -> String {
        guard let string = node.stringValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        return string
    }
}

// MARK: Boolean

extension Bool: NodeConvertibleType {
    public func toNode() throws -> Node {
        return Node(self)
    }
    
    public init(node: Node, context: Context) throws {
        self = try self.dynamicType.makeWith(node, context: context)
    }
    
    private static func makeWith(node: Node, context: Context) throws -> Bool {
        guard let bool = node.boolValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        return bool
    }
}

// MARK: UnsignedIntegerType

extension UInt: NodeConvertibleType {}
extension UInt8: NodeConvertibleType {}
extension UInt16: NodeConvertibleType {}
extension UInt32: NodeConvertibleType {}
extension UInt64: NodeConvertibleType {}

#if swift(>=3.0)
extension UnsignedInteger {
    public func toNode() throws -> Node {
        let double = Double(UIntMax(self.toUIntMax()))
        return Node(double)
    }
    
    public init(node: Node, context: Context) throws {
        self = try Self.makeWith(node, context: context)
    }
    
    private static func makeWith(node: Node, context: Context) throws -> Self {
        guard let int = node.uintValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        
        return self.init(int.toUIntMax())
    }
}
#else
    extension UnsignedIntegerType {
        public func toNode() throws -> Node {
            let double = Double(UIntMax(self.toUIntMax()))
            return Node(double)
        }
        
        public init(node: Node, context: Context) throws {
            self = try Self.makeWith(node, context: context)
        }
        
        private static func makeWith(node: Node, context: Context) throws -> Self {
            guard let int = node.uintValue else {
                throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
            }
            
            return self.init(int.toUIntMax())
        }
    }
#endif

// MARK: SignedIntegerType

extension Int: NodeConvertibleType {}
extension Int8: NodeConvertibleType {}
extension Int16: NodeConvertibleType {}
extension Int32: NodeConvertibleType {}
extension Int64: NodeConvertibleType {}

#if swift(>=3.0)
extension SignedInteger {
    public func toNode() throws -> Node {
        let double = Double(IntMax(self.toIntMax()))
        return Node(double)
    }
    
    public init(node: Node, context: Context) throws {
        self = try Self.makeWith(node, context: context)
    }
    
    private static func makeWith(node: Node, context: Context) throws -> Self {
        guard let int = node.intValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(Self.self)"))
        }
        
        return self.init(int.toIntMax())
    }
}
#else
    extension SignedIntegerType {
        public func toNode() throws -> Node {
            let double = Double(IntMax(self.toIntMax()))
            return Node(double)
        }
        
        public init(node: Node, context: Context) throws {
            self = try Self.makeWith(node, context: context)
        }
        
        private static func makeWith(node: Node, context: Context) throws -> Self {
            guard let int = node.intValue else {
                throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(Self.self)"))
            }
            
            return self.init(int.toIntMax())
        }
    }
#endif
// MARK: FloatingPointType

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

public protocol NodeConvertibleFloatingPointType: NodeConvertibleType {
    var doubleValue: Double { get }
    init(_ other: Double)
}

extension NodeConvertibleFloatingPointType {
    public func toNode() throws -> Node {
        return Node(doubleValue)
    }
    
    public init(node: Node, context: Context) throws {
        self = try Self.makeWith(node, context: context)
    }
    
    private static func makeWith(node: Node, context: Context) throws -> Self {
        guard let double = node.doubleValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(Self.self)"))
        }
        return self.init(double)
    }
}

// MARK: Convenience

extension Node {
    public init(_ dictionary: [String : NodeConvertibleType]) throws {
        var mutable: [String : Node] = [:]
        try dictionary.forEach { key, value in
            mutable[key] = try value.toNode()
        }
        self = .ObjectValue(mutable)
    }
}
