//
//  StreamDeserializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/9/16.
//
//

import Foundation

//---------------------------------
// MARK: Deserializaton Stream
//---------------------------------

/// Processes the data strem and notifies the delegate when a new node is
public protocol DeserializationStreamDelegate {
    /**
     Returns `Node`s as they are deserialized from the stream.
     - parameter node: The node that was deserialized.
     - note: The deserializer for a specific file type determines how it will return nodes. Generally the deserializer will return completed top level nodes.
     */
    func deserializerDidCompleteNode(node: Node)
    
    /**
     The deserializer encountered an error while parsing the stream.
     - parameter error: The error that occured.
     */
    func deserializerFailedWithError(error: ErrorProtocol)
}

public class StreamDeserializer: NSObject, NSStreamDelegate {
    
    //---------------------------------
    // MARK: Properties
    //---------------------------------
    
    /// The input stream containing the data to process.
    internal let stream: NSInputStream
    
    /// The deserializer to use.
    internal let deserializer: Deserializer
    
    /// The deserialization delegate
    internal let delegate: DeserializationStreamDelegate
    
    //---------------------------------
    // MARK: Initalization
    //---------------------------------
    
    /**
     Initalizes a deserializer with the given data.
     - parameter data: The data to parse into a node.
     - returns: A new deserializer object that will parse the given data.
     */
    public convenience init(data: String, deserializer: Deserializer, delegate: DeserializationStreamDelegate) throws {
        if let data = data.data(using: NSUTF8StringEncoding) {
            try self.init(data: data, deserializer: deserializer, delegate: delegate)
        } else {
            throw DeserializationError.EmptyInput
        }
    }
    
    /**
     Initalizes a deserializer with the given data.
     - parameter data: The data to parse into a node.
     - returns: A new deserializer object that will parse the given data.
     */
    public convenience init(data: NSData, deserializer: Deserializer, delegate: DeserializationStreamDelegate) throws {
        self.init(stream: NSInputStream(data: data), deserializer: deserializer, delegate: delegate)
    }
    
    /**
     Initalizes a deserializer with the file at the given path.
     - parameter fileAtPath: The path to the file to deserialize.
     - returns: A new deserializer object that will parse the given file.
     */
    public convenience init(fileAtPath path: String, deserializer: Deserializer, delegate: DeserializationStreamDelegate) throws {
        if let stream = NSInputStream(fileAtPath: path) {
            self.init(stream: stream, deserializer: deserializer, delegate: delegate)
        } else {
            throw DeserializationError.EmptyInput
        }
    }
    
    /**
     Initalizes a deserializer with the file at the given URL.
     - parameter url: The url to the file to deserialize.
     - returns: A new deserializer object that will parse the given file.
     */
    public convenience init(url: NSURL, deserializer: Deserializer, delegate: DeserializationStreamDelegate) throws {
        if let stream = NSInputStream(url: url) {
            self.init(stream: stream, deserializer: deserializer, delegate: delegate)
        } else {
            throw DeserializationError.EmptyInput
        }
    }
    
    /**
     Initalizes a deserializer with the given input stream.
     - parameter stream: The stream to deserialize.
     - returns: A new deserializer object that will parse the given input stream.
     */
    required public init(stream: NSInputStream, deserializer: Deserializer, delegate: DeserializationStreamDelegate) {
        self.stream = stream
        self.deserializer = deserializer
        self.delegate = delegate
        super.init()
    }
    
    //---------------------------------
    // MARK: Parsing
    //---------------------------------
    
    /**
     Deserializes the data given into a data node if possible. Runs as a synchronous operation.
     - note: This method parses the data in its entirety, then returns a node.
     - returns: A node representing the data the deserializer was initialized with.
     - throws: Throws a `DeserializationError` if the data is unable to be deserialized.
     */
    public func parse() throws -> Node {
        // Open the stream
        stream.schedule(in: NSRunLoop.current(), forMode: NSDefaultRunLoopMode)
        stream.open()
        
        // Process the stream synchronously until it is parsed in full
        mainLoop: while true {
            switch stream.streamStatus {
            case .open:
                // Read from the stream.
                while stream.hasBytesAvailable {
                    var buffer = [UInt8](repeating: 0, count: 2048)
                    let length = stream.read(&buffer, maxLength: 2048)
                    if length > 0 {
                        if let output = String(bytes: buffer, encoding: NSUTF8StringEncoding) {
                            try deserializer.parse(data: output.unicodeScalars)
                        }
                    }
                }
                break
            case .atEnd:
                // Finished
                break mainLoop
            case .closed:
                // Finished
                break mainLoop
            case .error:
                throw stream.streamError!
            default:
                break
            }
        }
        
        // Close the stream
        stream.close()
        stream.remove(from: NSRunLoop.current(), forMode: NSDefaultRunLoopMode)
        
        return try deserializer.finish()
    }
    
    /**
     Deserializes the data given into a data node(s) if possible. Returning them to the delegate.
     */
    public func parseStream() {
        stream.delegate = self
        stream.schedule(in: NSRunLoop.current(), forMode: NSDefaultRunLoopMode)
        stream.open()
    }
    
    //---------------------------------
    // MARK: Stream Delegate
    //---------------------------------
    
    @objc public func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch eventCode {
        case NSStreamEvent.hasBytesAvailable:
            // Read from the stream.
            while stream.hasBytesAvailable {
                var buffer = [UInt8](repeating: 0, count: 2048)
                let length = stream.read(&buffer, maxLength: 2048)
                if length > 0 {
                    if let output = String(bytes: buffer, encoding: NSUTF8StringEncoding) {
                        do {
                            try deserializer.parse(data: output.unicodeScalars)
                        } catch {
                            delegate.deserializerFailedWithError(error: DeserializationError.Unknown)
                            // Close the stream
                            stream.close()
                            stream.remove(from: NSRunLoop.current(), forMode: NSDefaultRunLoopMode)
                        }
                    }
                }
            }
            break
        case NSStreamEvent.errorOccurred:
            delegate.deserializerFailedWithError(error: stream.streamError!)
            // Close the stream
            stream.close()
            stream.remove(from: NSRunLoop.current(), forMode: NSDefaultRunLoopMode)
            break
        case NSStreamEvent.endEncountered:
            do {
                let node = try deserializer.finish()
                delegate.deserializerDidCompleteNode(node: node)
            } catch {
                delegate.deserializerFailedWithError(error: DeserializationError.Unknown)
                // Close the stream
                stream.close()
                stream.remove(from: NSRunLoop.current(), forMode: NSDefaultRunLoopMode)
            }
            break
        default:
            break
        }
    }
}
