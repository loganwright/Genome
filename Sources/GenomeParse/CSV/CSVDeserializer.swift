//
//  CSVDeserializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/9/16.
//
//

/**
 Deserializes a CSV file into an array of `Node` objectacoording to the specification: [RFC4180](https://tools.ietf.org/html/rfc4180) with the options of changing the delimeter, and and parsing basic types.
 */
public class CSVDeserializer: Deserializer {
    
    //---------------------------------
    // MARK: Properties
    //---------------------------------
    
    /// The delimeter to use when separating values.
    public var delimeter: UnicodeScalar = FileConstants.comma
    
    /// Whether or not to attempt to parse the string values into other types.
    public var parseTypes: Bool = true
    
    /// Whether or not the headers were preset.
    /// - default: `true`
    private let firstRowHeaders: Bool
    
    /// The header values.
    private var headers: [String] = []
    
    /// The document's headers.
    private var documentHeaders: [String] = []
    
    //---------------------------------
    // MARK: Initalization
    //---------------------------------
    
    public required init(data: String.UnicodeScalarView) {
        firstRowHeaders = true
        super.init(data: data)
    }
    
    /**
     Initalizes a deserializer with the given data.
     - parameter data: The data to parse into a node.
     - parameter isFirstRowHeaders: Whether or not the first row of the CSV file is a header row.
     - returns: A new deserializer object that will parse the given data.
     - note: If the first row is a header, the CSV will be parsed as an array of objects. If it is not, the CSV file will be parsed as an array of arrays.
     */
    init(data: String.UnicodeScalarView, isFirstRowHeaders hasHeaders: Bool) {
        firstRowHeaders = hasHeaders
        super.init(data: data)
    }
    
    /**
     Initalizes a deserializer with the given data.
     - parameter data: The data to parse into a node.
     - parameter isFirstRowHeaders: Whether or not the first row of the CSV file is a header row.
     - returns: A new deserializer object that will parse the given data.
     - note: If the first row is a header, the CSV will be parsed as an array of objects. If it is not, the CSV file will be parsed as an array of arrays.
     */
    convenience init(data: String, isFirstRowHeaders hasHeaders: Bool) {
        self.init(data: data.unicodeScalars, isFirstRowHeaders: hasHeaders)
    }
    
    /**
     Initalizes a deserializer with the given data.
     - parameter data: The data to parse into a node.
     - parameter headers: The headers to retreive from the CSV file. Additional columns will not be loaded.
     - returns: A new deserializer object that will parse the given data.
     - note: The CSV will be parsed as an array of objects.
     */
    init(data: String.UnicodeScalarView, headers: [String]) {
        firstRowHeaders = true
        self.headers = headers
        super.init(data: data)
    }
    
    /**
     Initalizes a deserializer with the given data.
     - parameter data: The data to parse into a node.
     - parameter headers: The headers to retreive from the CSV file. Additional columns will not be loaded.
     - returns: A new deserializer object that will parse the given data.
     - note: The CSV will be parsed as an array of objects.
     */
    convenience init(data: String, headers: [String]) {
        self.init(data: data.unicodeScalars, headers: headers)
    }
    
    //---------------------------------
    // MARK: Parsing
    //---------------------------------
    
    /// States the deserializer can be in.
    private enum DeserializationState {
        /// Started the header
        case StartHeader
        /// A key is being deserialized.
        case Key(escaped: Bool)
        /// A new line has begun.
        case NewLine
        /// A new column has begun.
        case NewColumn
        /// A value is being deserialized.
        case Value(escaped: Bool)
    }
    
    override func parse(data: String.UnicodeScalarView) throws {
        // Call super to append the data.
        try super.parse(data: data)
        // Restart the parser if necessary.
        
    }
}

