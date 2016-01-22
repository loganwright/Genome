//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: Map

/// This class is designed to serve as an adaptor between the raw node and the values.  In this way we can interject behavior that assists in mapping between the two.
public final class Map {
    
    // MARK: Map Type
    
    /**
    The representative type of mapping operation
    
    - ToNode:   transforming the object into a node dictionary representation
    - FromNode: transforming a node dictionary representation into an object
    */
    public enum OperationType {
        case ToNode
        case FromNode
    }
    
    /// The type of operation for the current map
    public let type: OperationType
    
    /// If the mapping operation were converted to Node (Type.ToNode)
    public private(set) var toNode: Node = .ObjectValue([:])
    
    /// The backing Node being mapped
    public let node: Node
    
    /// The greater context in which the mapping takes place
    public let context: Context
    
    // MARK: Private
    
    /// The last key accessed -- Used to reverse Node Operations
    internal private(set) var lastKey: KeyType = .KeyPath("")
    
    /// The last retrieved result.  Used in operators to set value
    internal private(set) var result: Node? {
        didSet {
            if let unwrapped = result where unwrapped.isNull {
                result = nil
            }
        }
    }
    
    // MARK: Initialization
    
    /**
    The designated initializer
    
    :param: node    the node that will be used in the mapping
    :param: context the context that will be used in the mapping
    
    :returns: an initialized map
    */
    public init(node: Node, context: Context = EmptyNode) {
        self.node = node
        self.context = context
        self.type = .FromNode
    }
    
    public init() {
        self.node = [:]
        self.context = EmptyNode
        self.type = .ToNode
    }
    
    // MARK: Subscript
    
    /**
    Basic subscripting
    
    :param: keyPath the keypath to use when getting the value from the backing node
    
    :returns: returns an instance of self that can be passed to the mappable operator
    */
    public subscript(keyType: KeyType) -> Map {
        lastKey = keyType
        switch keyType {
        case let .Key(key):
            result = node[key]
        case let .KeyPath(keyPath):
            result = node.gnm_valueForKeyPath(keyPath)
        }
        return self
    }
    
    // MARK: To Node
    
    /**
    Accept 'Any' type and convert for things like Int that don't conform to AnyObject, but can be put into Node Dict and pass a cast to 'AnyObject'
    
    :param: any the value to set to the node for the value of the last key
    */
    internal func setToLastKey(node: Node?) throws {
        guard let node = node else { return }
        switch lastKey {
        case let .Key(key):
            toNode[key] = node
        case let .KeyPath(keyPath):
            toNode.gnm_setValue(node, forKeyPath: keyPath)
        }
    }
}

extension Map {
    internal func setToLastKey<T : NodeConvertibleType>(any: T?) throws {
        try setToLastKey(any?.nodeRepresentation())
    }
    
    internal func setToLastKey<T : NodeConvertibleType>(any: [T]?) throws {
        try setToLastKey(any?.nodeRepresentation())
    }
    
    internal func setToLastKey<T : NodeConvertibleType>(any: [[T]]?) throws {
        guard let any = any else { return }
        let node: [Node] = try any.map { innerArray in
            return try innerArray.nodeRepresentation()
        }
        try setToLastKey(Node.from(node))
    }
    
    internal func setToLastKey<T : NodeConvertibleType>(any: [String : T]?) throws {
        guard let any = any else { return }
        var node: [String : Node] = [:]
        try any.forEach { key, value in
            node[key] = try value.nodeRepresentation()
        }
        try setToLastKey(.from(node))
    }
    
    internal func setToLastKey<T : NodeConvertibleType>(any: [String : [T]]?) throws {
        guard let any = any else { return }
        var node: [String : Node] = [:]
        try any.forEach { key, value in
            node[key] = try value.nodeRepresentation()
        }
        try setToLastKey(.from(node))
    }
    
    internal func setToLastKey<T : NodeConvertibleType>(any: Set<T>?) throws {
        try setToLastKey(any?.nodeRepresentation())
    }
}

