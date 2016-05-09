//
//  StreamSerializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/9/16.
//
//

import Foundation

//---------------------------------
// MARK: Deserializaton Stream
//---------------------------------

/// Notifies the delegate that the stream serializer state changed.
public protocol SerializationStreamDelegate {
    /**
     The deserializer encountered an error while parsing the stream.
     - parameter error: The error that occured.
     */
    func serializerFailedWithError(error: ErrorProtocol)
}

public class StreamSerializer: NSObject, NSStreamDelegate, SerializerSerializationDelegate {
    
    //---------------------------------
    // MARK: Properties
    //---------------------------------
    
    /// The input stream containing the data to process.
    internal let stream: NSOutputStream
    
    /// The deserializer to use.
    internal let serializer: Serializer
    
    /// The deserialization delegate
    internal let delegate: SerializationStreamDelegate
    
    /// Whether or not the stream is ready for more data.
    internal var streamReady: Bool = true
    
    /// The data to write
    internal var data: NSMutableData = NSMutableData()
    
    //---------------------------------
    // MARK: Initalization
    //---------------------------------
    
    /**
     Initalizes a deserializer with the given data.
     - parameter data: The data to parse into a node.
     - returns: A new deserializer object that will parse the given data.
     */
    required public init(stream: NSOutputStream, serializer: Serializer, delegate: SerializationStreamDelegate) throws {
        self.stream = stream
        self.serializer = serializer
        self.delegate = delegate
        super.init()
        serializer.serializationDelegate = self
    }
    
    //---------------------------------
    // MARK: Parsing
    //---------------------------------
    
    /**
     Serializes the node given into data if possible.
     - parameter delegate: The stream delegate that will processed deserialized nodes as they are created.
     - parameter topLevelObjectsOnly: Whether or not to send every object to the delegate as its completed, or only the top level object.
     - note: This method only loads into memory what is loaded by the input stream, and will only store the current top level node in memory. This is the method that should be used if handling a large amount of data. Exact implementations of how `topLevelObjectsOnly` will vary based on the deserializer being used.
     - throws: Throws a `SerializationError` if the data is unable to be deserialized.
     */
    func parseStream() throws {
        // Open the stream and begin parsing.
        stream.delegate = self
        stream.schedule(in: NSRunLoop.current(), forMode: NSDefaultRunLoopMode)
        stream.open()
        try serializer.parse()
    }
    
    func serializerSerializedData(data: String) {
        self.data.append(data.data(using: NSUTF8StringEncoding)!)
        if streamReady {
            stream(aStream: stream, handleEvent: NSStreamEvent.hasSpaceAvailable)
        }
    }
    
    func serializerFinished() {
        stream.close()
        stream.remove(from: NSRunLoop.current(), forMode: NSDefaultRunLoopMode)
    }
    
    //---------------------------------
    // MARK: Stream Delegate
    //---------------------------------
    
    @objc public func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch eventCode {
        case NSStreamEvent.hasSpaceAvailable:
            // Check to see if there is data to write.
            if data.length == 0 {
                streamReady = true
                return
            } else {
                streamReady = false
            }
            // Read from the stream.
            while stream.hasSpaceAvailable {
                // Only grab the bytes that exist, upto 1024 bytes.
                var length = min(data.length, 1024)
                var buffer = [UInt8](repeating: 0, count: 2048)
                length = stream.write(&buffer, maxLength: length)
                // Once written, remove the bytes from the beginning of the data buffer.
                if length > 0 {
                    data.replaceBytes(in: NSMakeRange(0, length), withBytes: nil, length: 0)
                } else if length == -1 {
                    return
                }
            }
            break
        case NSStreamEvent.errorOccurred:
            delegate.serializerFailedWithError(error: stream.streamError!)
            // Close the stream
            stream.close()
            stream.remove(from: NSRunLoop.current(), forMode: NSDefaultRunLoopMode)
            break
        default:
            break
        }
    }
}
