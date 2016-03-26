//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

/// This class is designed to serve as an adaptor between the raw node and the values.  In this way we can interject behavior that assists in mapping between the two.
public final class Map {
    
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
    
    /// The greater context in which the mapping takes place
    public let context: Context

    /// The backing Node being mapped
    public private(set) var node: Node
    
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
     A convenience mappable initializer that takes any conforming backing data
     
     :param: node    the backing data that will be used in the mapping
     :param: context the context that will be used in the mapping
     */
    public convenience init<T: BackingDataType>(node data: T, context: Context = EmptyNode) throws {
        self.init(node: try data.toNode(), context: context)
    }
    
    /**
     The designated initializer for mapping from Node
     
     :param: node    the node that will be used in the mapping
     :param: context the context that will be used in the mapping
     */
    public init(node: Node, context: Context = EmptyNode) {
        self.type = .FromNode
        
        self.node = node
        self.context = context
    }
    
    /**
     The designated initializer for mapping to Node
     
     - returns: an initialized toNode map ready to generate a node
     */
    public init() {
        self.type = .ToNode
        
        self.node = [:]
        self.context = EmptyNode
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
        try assertOperationTypeToNode()
        guard let node = node else { return }
        
        switch lastKey {
        case let .Key(key):
            self.node[key] = node
        case let .KeyPath(keyPath):
            self.node.gnm_setValue(node, forKeyPath: keyPath)
        }
    }
    
    /**
     Ensure that we're running the appropriate operation type
     */
    private func assertOperationTypeToNode() throws {
        if type != .ToNode {
            let error = MappingError
                .UnexpectedOperationType("Received mapping operation of type: \(type) expected: \(OperationType.ToNode)")
            throw logError(error)
        }
    }
}

extension Map {
    internal func setToLastKey<T : NodeConvertibleType>(any: T?) throws {
        try setToLastKey(any?.toNode())
    }
    
    internal func setToLastKey<T : NodeConvertibleType>(any: [T]?) throws {
        try setToLastKey(any?.toNode())
    }
    
    internal func setToLastKey<T : NodeConvertibleType>(any: [[T]]?) throws {
        guard let any = any else { return }
        let node: [Node] = try any.map { innerArray in
            return try innerArray.toNode()
        }
        try setToLastKey(Node(node))
    }
    
    internal func setToLastKey<T : NodeConvertibleType>(any: [String : T]?) throws {
        guard let any = any else { return }
        var node: [String : Node] = [:]
        try any.forEach { key, value in
            node[key] = try value.toNode()
        }
        try setToLastKey(Node(node))
    }
    
    internal func setToLastKey<T : NodeConvertibleType>(any: [String : [T]]?) throws {
        guard let any = any else { return }
        var node: [String : Node] = [:]
        try any.forEach { key, value in
            node[key] = try value.toNode()
        }
        try setToLastKey(Node(node))
    }
    
    internal func setToLastKey<T : NodeConvertibleType>(any: Set<T>?) throws {
        try setToLastKey(any?.toNode())
    }
}

