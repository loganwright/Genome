//
//  Deserializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/10/16.
//
//

@_exported import Genome

//---------------------------------
// MARK: Deserialization Errors
//---------------------------------

/// Errors that can be thrown by deserializers.
public enum DeserializationError: ErrorProtocol {
    /// Some unknown error, usually indicates something not yet implemented.
    case Unknown
    /// Input data was either empty or contained only whitespace.
    case EmptyInput
    /// Some character that does not follow file specifications was found.
    case UnexpectedCharacter(lineNumber: UInt, characterNumber: UInt)
    /// A string was opened but never closed.
    case UnterminatedString
    /// Any unicode parsing errors will result in this error.
    case InvalidUnicode
    /// A keyword, like `null`, `true`, or `false` was expected but something else was in the input.
    case UnexpectedKeyword(lineNumber: UInt, characterNumber: UInt)
    /// Encountered a number that couldn't be stored, or is invalid.
    case InvalidNumber(lineNumber: UInt, characterNumber: UInt)
    /// End of file reached, not always an actual error.
    case EndOfFile
}

//---------------------------------
// MARK: Deserializer
//---------------------------------

/**
 Deserializes file data into a structure of `Node` objects.
  - note: Deserializes that are subclasses of this class are expected to create the entire output object before returning it. Subclasses of this class are best suited to quickly deserializing "small" amounts of data quickly. They should be written to value speed over memory consumption.
 */
public class Deserializer {
    
    //---------------------------------
    // MARK: Properties
    //---------------------------------
    
    /// The data being processed.
    internal var data: String.UnicodeScalarView!
    
    /// A generator that iterates of the data to be deserialized.
    internal var generator: String.UnicodeScalarView.Generator!
    
    // The current scalar.
    internal private(set) var scalar: UnicodeScalar!
    
    /// The current index the generator is on.
    private var index: Int = -1
    
    /// The current line number.
    internal var lineNumber: UInt = 0
    
    /// The current character number.
    internal var characterNumber: UInt = 0
    
    //---------------------------------
    // MARK: Initalization
    //---------------------------------
    
    //---------------------------------
    // MARK: Parsing
    //---------------------------------
    
    /**
     Deserializes the data given into a data node if possible.
     - returns: A node representing the data the deserializer was initialized with.
     - throws: Throws a `DeserializationError` if the data is unable to be deserialized.
     */
    public func parse(data: String) throws -> Node {
        return try parse(data: data.unicodeScalars)
    }
    
    /**
     Deserializes the data given into a data node if possible.
     - returns: A node representing the data the deserializer was initialized with.
     - throws: Throws a `DeserializationError` if the data is unable to be deserialized.
     */
    public func parse(data: String.UnicodeScalarView) throws -> Node {
        self.data = data
        self.generator = data.makeIterator()
        return .null
    }
    
    /**
     Moves the parser's "index" to the next character in the sequence.
     - throws: `DeserializationError.EndOfFile`. Usually not a fatal error.
     */
    internal final func nextScalar() throws {
        // If there is a next character
        if let sc = generator.next() {
            // Set the current scalar to the next one.
            scalar = sc
            // Increment the index
            index += 1
            // Increment which character we are on.
            characterNumber += 1
            // Increment the line number if necessary.
            if scalar == FileConstants.carriageReturn || scalar == FileConstants.formFeed {
                characterNumber = 0
                lineNumber += 1
            }
        } else {
            // We reached the end of the file.
            throw DeserializationError.EndOfFile
        }
    }
    
}