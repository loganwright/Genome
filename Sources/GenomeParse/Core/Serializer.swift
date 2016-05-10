//
//  Serializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/10/16.
//
//

//---------------------------------
// MARK: Serialization Errors
//---------------------------------

/// Errors that can be thrown by serializers.
public enum SerializationError: ErrorProtocol {
    /// An unknown error occured.
    case Unknown
    /// An invalid number was encountered.
    case InvalidNumber(reason: String)
    /// The type of node encountered is not supported by the serializer.
    case UnsupportedNodeType(reason: String)
    /// There was no input to process.
    case EmptyInput
}

//---------------------------------
// MARK: Serializer
//---------------------------------

/**
 Serializes `Nodes` into file data.
 - note: Serializers that are subclasses of this class are expected to create the entire output string before returning it. Subclasses of this class are best suited to quickly serializing "small" amounts of data quickly. They should be written to value speed over memory consumption. 
 */
public class Serializer {
    
    //---------------------------------
    // MARK: Properties
    //---------------------------------
    
    /// The data being processed.
    internal var rootNode: Node
    
    /// The line endings to use.
    public var lineEndings: LineEndings = .Unix
    
    /// The string that stores the output.
    internal var output: String = ""
    
    //---------------------------------
    // MARK: Initalization
    //---------------------------------
    
    /**
     Initalizes a deserializer with the given node.
     - parameter node: The node to parse into data.
     - returns: A new deserializer object that will parse the given node.
     */
    public init(node: Node) {
        rootNode = node
    }
    
    //---------------------------------
    // MARK: Parsing
    //---------------------------------
    
    /**
     Serializes the node given into a file if possible.
     - returns: Data representing the node the serializer was initialized with.
     - throws: Throws a `SerializationError` if a node is unable to be serialized.
     */
    func parse() throws -> String? {
        fatalError("This method must be overriden by subclasses.")
    }
}
