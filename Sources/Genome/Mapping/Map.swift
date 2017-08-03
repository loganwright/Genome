public struct GenomeContext: Context {
    public static let `default` = GenomeContext()
}

extension Map {
    public static var defaultContext: Context? { return GenomeContext.default }
}

//static var defaultContext: Context? { get }
//
//var wrapped: StructuredData { get set }
//var context: Context { get }
//init(_ wrapped: StructuredData, in context: Context?)

/// This class is designed to serve as an adaptor between the raw node and the values.  In this way we can interject behavior that assists in mapping between the two.
public final class Map: StructuredDataWrapper {

    public var wrapped: StructuredData {
        get {
            return node.wrapped
        }
        set {
            node = Node(wrapped, node.context)
        }
    }

    
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
    public var node: Node
    
    // MARK: Private

    /// The last key accessed -- Used to reverse Node Operations
    internal fileprivate(set) var lastPath: [PathIndexer] = []
    
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
    public convenience init(
        node: NodeRepresentable,
        in context: Context = GenomeContext.default
    ) throws {
        let node = try node.makeNode(in: context)
        self.init(node: node, in: context)
    }

    public convenience init(
        _ wrapped: StructuredData,
        in context: Context? = nil
    ) {
        let node = wrapped.makeNode(in: context)
        self.init(
            node: node,
            in: context ?? GenomeContext.default
        )
    }
    
    /**
     The designated initializer for mapping from Node
     
     :param: node    the node that will be used in the mapping
     :param: context the context that will be used in the mapping
     */
    public init(
        node: Node,
        in context: Context = GenomeContext.default
    ) {
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
        self.context = GenomeContext.default
    }
}

// MARK: Subscript

extension Map {
    /**
     Basic subscripting

     :param: keyPath the keypath to use when getting the value from the backing node

     :returns: returns an instance of self that can be passed to the mappable operator
     */
    public subscript(keys: PathIndexer...) -> Map {
        return self[keys]
    }

    /**
     Basic subscripting

     :param: keyPath the keypath to use when getting the value from the backing node

     :returns: returns an instance of self that can be passed to the mappable operator
     */
    public subscript(keys: [PathIndexer]) -> Map {
        lastPath = keys
        result = node[keys]
        return self
    }

    public subscript(path path: String) -> Map {
        let components = path.characters
            .split(separator: ".")
            .map { String($0) }
        return self[components]
    }
}

// MARK: Setting

extension Map {
    internal func setToLastPath(_ newValue: Node?) throws {
        guard let newValue = newValue else { return }
        node[lastPath] = newValue
    }

    internal func setToLastPath<T : NodeConvertible>(_ any: T?) throws {
        try setToLastPath(any?.makeNode(in: GenomeContext.default))
    }
    
    internal func setToLastPath<T : NodeConvertible>(_ any: [T]?) throws {
        try setToLastPath(any?.makeNode(in: GenomeContext.default))
    }
    
    internal func setToLastPath<T : NodeConvertible>(_ any: [[T]]?) throws {
        guard let any = any else { return }
        let node: [Node] = try any.map { innerArray in
            return try innerArray.makeNode(in: GenomeContext.default)
        }
        try setToLastPath(node.makeNode(in: GenomeContext.default))
    }
    
    internal func setToLastPath<T : NodeConvertible>(_ any: [String : T]?) throws {
        guard let any = any else { return }
        var node: [String : Node] = [:]
        try any.forEach { key, value in
            node[key] = try value.makeNode(in: GenomeContext.default)
        }
        try setToLastPath(Node(node))
    }
    
    internal func setToLastPath<T : NodeConvertible>(_ any: [String : [T]]?) throws {
        guard let any = any else { return }
        var node: [String : Node] = [:]
        try any.forEach { key, value in
            node[key] = try value.makeNode(in: GenomeContext.default)
        }
        try setToLastPath(Node(node))
    }
    
    internal func setToLastPath<T : NodeConvertible>(_ any: Set<T>?) throws {
        try setToLastPath(any?.makeNode(in: GenomeContext.default))
    }
}
