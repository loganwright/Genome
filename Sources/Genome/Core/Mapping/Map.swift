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
    public fileprivate(set) var node: Node
    
    // MARK: Private

    /// The last key accessed -- Used to reverse Node Operations
    internal fileprivate(set) var lastPath: [PathIndex] = []
    
    /// The last retrieved result.  Used in operators to set value
    internal fileprivate(set) var result: Node? {
        didSet {
            if let unwrapped = result, unwrapped.isNull {
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
    public convenience init<T: NodeRepresentable>(with data: T, in context: Context = EmptyNode) throws {
        self.init(with: try data.makeNode(), in: context)
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
    public subscript(keys: PathIndex...) -> Map {
        return self[keys]
    }

    /**
     Basic subscripting

     :param: keyPath the keypath to use when getting the value from the backing node

     :returns: returns an instance of self that can be passed to the mappable operator
     */
    public subscript(keys: [PathIndex]) -> Map {
        lastPath = keys
        result = node[keys]
        return self
    }

    public subscript(path path: String) -> Map {
        let components = path
            .keyPathComponents()
        return self[components]
    }
}


extension String {
    fileprivate func keyPathComponents() -> [PathIndex] {
        return characters
            .split(separator: ".")
            .map { String($0) }
    }
}

// MARK: Setting

extension Map {
    internal func setToLastPath(_ newValue: Node?) throws {
        try type.assert(equals: .toNode)
        guard let newValue = newValue else { return }
        node[lastPath] = newValue
    }

    internal func setToLastPath<T : NodeConvertible>(_ any: T?) throws {
        try setToLastPath(any?.makeNode())
    }
    
    internal func setToLastPath<T : NodeConvertible>(_ any: [T]?) throws {
        try setToLastPath(any?.makeNode())
    }
    
    internal func setToLastPath<T : NodeConvertible>(_ any: [[T]]?) throws {
        guard let any = any else { return }
        let node: [Node] = try any.map { innerArray in
            return try innerArray.makeNode()
        }
        try setToLastPath(node.makeNode())
    }
    
    internal func setToLastPath<T : NodeConvertible>(_ any: [String : T]?) throws {
        guard let any = any else { return }
        var node: [String : Node] = [:]
        try any.forEach { key, value in
            node[key] = try value.makeNode()
        }
        try setToLastPath(Node(node))
    }
    
    internal func setToLastPath<T : NodeConvertible>(_ any: [String : [T]]?) throws {
        guard let any = any else { return }
        var node: [String : Node] = [:]
        try any.forEach { key, value in
            node[key] = try value.makeNode()
        }
        try setToLastPath(Node(node))
    }
    
    internal func setToLastPath<T : NodeConvertible>(_ any: Set<T>?) throws {
        try setToLastPath(any?.makeNode())
    }
}

extension Map.OperationType {
    func assert(equals expected: Map.OperationType) throws {
        if self != expected {
            throw ErrorFactory.unexpectedOperation(got: self, expected: expected)
        }
    }
}

