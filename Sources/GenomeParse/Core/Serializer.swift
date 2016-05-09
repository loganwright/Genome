//
//  Serializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/9/16.
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
// MARK: Serialzation Progress
//---------------------------------

/// The protocol that informs the delegate how much data has been processed.
public protocol SerializerProgressDelegate {
    /**
     Notifies the delegate that the serializer has processed data.
     - parameter totalBytesProcessed: The total number of bytes that has been processed.
     */
    func serializerDidProcessData(totalBytesProcessed: Int64)
}

//---------------------------------
// MARK: Serialzation Delegate
//---------------------------------

/// The r=protocol that allows a delegate to process the output data stream.
internal protocol SerializerSerializationDelegate {
    /**
     Notifies the delegate that the serializer has processed data and has serialized data to append to the output.
     - parameter data: The string data to append to the output.
     */
    func serializerSerialized(data: String)
    
    /**
     Notifies the delegate that the serializer has finished serializing.
     */
    func serializerFinished()
}

/// An internal class to collect the data stream into a string.
internal class SerializerConcatenate: SerializerSerializationDelegate {
    var output: String = ""
    func serializerSerialized(data: String) {
        output.append(data)
    }
    func serializerFinished() {}
}

//---------------------------------
// MARK: Serializer
//---------------------------------

/**
 Serializes `Nodes` into file data.
 */
public class Serializer {
    
    //---------------------------------
    // MARK: Properties
    //---------------------------------
    
    /// The delegate that will get notified of the progress that the deserialzer is making.
    public var progressDelegate: DeserializationProgressDelegate?
    
    /// The data being processed.
    internal var rootNode: Node
    
    /// The line endings to use.
    public var lineEndings: LineEndings = .Unix
    
    /// The output delegate.
    internal var serializationDelegate: SerializerSerializationDelegate = SerializerConcatenate()
    
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
