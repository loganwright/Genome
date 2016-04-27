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
        case toNode
        case fromNode
    }
    
    /// The type of operation for the current map
    public let type: OperationType
    
    /// The greater context in which the mapping takes place
    public let context: Context

    /// The backing Node being mapped
    public private(set) var node: Node
    
    // MARK: Private

    // TODO: Rename
    /// The last key accessed -- Used to reverse Node Operations
    internal private(set) var lastKey: [NodeIndexable] = []
    
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
    public convenience init<T: BackingData>(with data: T, in context: Context = EmptyNode) throws {
        self.init(with: try data.toNode(), in: context)
    }
    
    /**
     The designated initializer for mapping from Node
     
     :param: node    the node that will be used in the mapping
     :param: context the context that will be used in the mapping
     */
    public init(with node: Node, in context: Context = EmptyNode) {
        self.type = .fromNode
        
        self.node = node
        self.context = context
    }
    
    /**
     The designated initializer for mapping to Node
     
     - returns: an initialized toNode map ready to generate a node
     */
    public init() {
        self.type = .toNode
        
        self.node = [:]
        self.context = EmptyNode
    }
}

// MARK: Subscript

extension Map {
    /**
     Basic subscripting

     :param: keyPath the keypath to use when getting the value from the backing node

     :returns: returns an instance of self that can be passed to the mappable operator
     */
    public subscript(keys: NodeIndexable...) -> Map {
        return self[keys]
    }

    /**
     Basic subscripting

     :param: keyPath the keypath to use when getting the value from the backing node

     :returns: returns an instance of self that can be passed to the mappable operator
     */
    public subscript(keys: [NodeIndexable]) -> Map {
        lastKey = keys
        result = node[keys]
        return self
    }

    public subscript(path path: String) -> Map {
        let components = path
            .components(separatedBy: ".")
            .map { $0 as NodeIndexable }
        return self[components]
    }
}

// MARK: Setting

extension Map {
    internal func setToLastKey(_ newValue: Node?) throws {
        try type.assert(equals: .toNode)
        guard let newValue = newValue else { return }
        node[lastKey] = newValue
    }

    internal func setToLastKey<T : NodeConvertible>(_ any: T?) throws {
        try setToLastKey(any?.toNode())
    }
    
    internal func setToLastKey<T : NodeConvertible>(_ any: [T]?) throws {
        try setToLastKey(any?.toNode())
    }
    
    internal func setToLastKey<T : NodeConvertible>(_ any: [[T]]?) throws {
        guard let any = any else { return }
        let node: [Node] = try any.map { innerArray in
            return try innerArray.toNode()
        }
        try setToLastKey(node.toNode())
    }
    
    internal func setToLastKey<T : NodeConvertible>(_ any: [String : T]?) throws {
        guard let any = any else { return }
        var node: [String : Node] = [:]
        try any.forEach { key, value in
            node[key] = try value.toNode()
        }
        try setToLastKey(Node(node))
    }
    
    internal func setToLastKey<T : NodeConvertible>(_ any: [String : [T]]?) throws {
        guard let any = any else { return }
        var node: [String : Node] = [:]
        try any.forEach { key, value in
            node[key] = try value.toNode()
        }
        try setToLastKey(Node(node))
    }
    
    internal func setToLastKey<T : NodeConvertible>(_ any: Set<T>?) throws {
        try setToLastKey(any?.toNode())
    }
}

extension Map.OperationType {
    func assert(equals expected: Map.OperationType) throws {
        if self != expected {
            throw Error.unexpectedOperation(got: self, expected: expected)
        }
    }
}

