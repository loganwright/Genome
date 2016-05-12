//
//  CSVDeserializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/9/16.
//
//

@_exported import Genome

/**
 Deserializes CSV data into a `Node` representation.
 
 - note: This is a parser implementing [RC-4180](https://tools.ietf.org/html/rfc4180).
 - warning: Unless otherwise specified: The parser considers the top row a header row and will create objects with the keys specified in the header. The deserializer will also attempt to map certian keywords to different values unless configured otherwise. For example "true" and "false" will be converted to booleans, and pure numbers will be converted to a numerical type.
 */
public class CSVDeserializer: Deserializer {
    
    //---------------------------------
    // MARK: Properties
    //---------------------------------
    
    /// The delimeter to use when separating values.
    public var delimeter: UnicodeScalar = FileConstants.comma
    
    /// Whether or not to attempt to parse the string values into other types.
    public var parseTypes: Bool = true
    
    /// Whether or not to output the constants "true", "false", and "null" as capitalized strings.
    public var capitalizeConstants: Bool = false
    
    /// Whether or not the headers were preset.
    /// - default: `true`
    private let containsHeader: Bool
    
    /// The header values.
    private var headers: [String] = []
    
    //---------------------------------
    // MARK: Initalization
    //---------------------------------
    
    public required init(data: String.UnicodeScalarView) {
        containsHeader = true
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
        containsHeader = hasHeaders
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
        containsHeader = true
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
    
    public override func parse() throws -> Node {
        do {
            // Load the first scalar.
            try nextScalar()
            // Parse the headers if there are any.
            if containsHeader {
                try parseHeader()
            }
        } catch DeserializationError.EndOfFile {
            throw DeserializationError.EmptyInput
        }
        
        return try parseMainArray()
    }
    
    // MARK: - Header
    
    /// Parses the header keys for mapping values to objects.
    private func parseHeader() throws {
        // Iterate over the header keys
        outerLoop: repeat {
            switch scalar {
            case FileConstants.comma:
                try nextScalar()
            case FileConstants.carriageReturn, FileConstants.lineFeed:
                try nextScalar()
                break outerLoop
            default:
                if let key = try parseValue(processingHeader: true).node.string {
                    headers.append(key)
                }
            }
            
        } while true
    }
    
    // MARK: - Main Parse Loop
    
    /// Parses the main array of values
    private func parseMainArray() throws -> Node {
        var array: [Node] = []
        // Iterate over the rows
        outerLoop: repeat {
            switch scalar {
            case FileConstants.carriageReturn, FileConstants.lineFeed:
                // If an empty line, add a null value
                do {
                    array.append(.null)
                    try nextScalar()
                    lineNumber += 1
                } catch DeserializationError.EndOfFile {
                    break outerLoop
                }
            default:
                do {
                    // Append the row
                    if containsHeader {
                        array.append(try parseObject())
                    } else {
                        array.append(try parseArray())
                    }
                    // Skip the new line
                    try nextScalar()
                    lineNumber += 1
                } catch DeserializationError.EndOfFile {
                    break outerLoop
                }
            }
        } while true
        
        return .array(array)
    }
    
    /// Parses a line of values into an array.
    private func parseArray() throws -> Node {
        var array: [Node] = []
        var previousWasComma = false
        // Iterate the columns into arrays.
        outerLoop: repeat {
            switch scalar {
            case FileConstants.comma:
                // If the previous was a comma, there was an empty value.
                if previousWasComma {
                    array.append(.null)
                }
                previousWasComma = true
                try nextScalar()
            case FileConstants.carriageReturn, FileConstants.lineFeed:
                previousWasComma = false
                break outerLoop
            default:
                previousWasComma = false
                do {
                    let value = try parseValue()
                    array.append(value.node)
                    
                    if value.endOfFile == true {
                        break outerLoop
                    }
                    
                } catch DeserializationError.EndOfFile {
                    break outerLoop
                }
            }
            
        } while true
        
        return .array(array)
    }
    
    /// Parses a line of values into an object.
    private func parseObject() throws -> Node {
        var object: [String: Node] = [:]
        var previousWasComma = false
        // Iterate the columns into object values.
        var i = 0
        outerLoop: repeat {
            switch scalar {
            case FileConstants.comma:
                // If the previous was a comma, there was an empty value.
                if previousWasComma {
                    object[headers[i]] = Node.null
                }
                previousWasComma = true
                try nextScalar()
                // Iterate which key we are on.
                i += 1
                // If we surpassed the number of keys, return the object
                if i >= headers.count {
                    break outerLoop
                }
            case FileConstants.carriageReturn, FileConstants.lineFeed:
                previousWasComma = false
                break outerLoop
            default:
                previousWasComma = false
                // Add the value to the object
                do {
                    let value = try parseValue()
                    object[headers[i]] = value.node
                    if value.endOfFile == true {
                        break outerLoop
                    }
                } catch DeserializationError.EndOfFile {
                    break outerLoop
                }
            }
        } while true
        
        return .object(object)
    }
    
    /// Parses the columns.
    private func parseValue(processingHeader: Bool = false) throws -> (node: Node, endOfFile: Bool) {
        // Whether or not we are in a set of quotes. If we are double quotes and newlines are part of the string.
        var escaping = false
        // End of file
        var endOfFile = false
        // Check to see that the next token is a quotation mark.
        if scalar == FileConstants.quotationMark {
            // Skip opening quotation
            try nextScalar()
            escaping = true
        }
        
        // String storage
        var strBuilder = ""
        
        do {
            // Iterate over the objects.
            outerLoop: repeat {
                // First we should deal with the escape character and the terminating quote
                switch scalar {
                case FileConstants.comma:
                    if escaping {
                        // The comma is part of the string.
                        strBuilder.append(FileConstants.comma)
                        try nextScalar()
                    } else {
                        break outerLoop
                    }
                case FileConstants.lineFeed, FileConstants.carriageReturn:
                    if escaping {
                        // The new line is part of the string.
                        strBuilder.append(scalar)
                        try nextScalar()
                    } else {
                        break outerLoop
                    }
                case FileConstants.quotationMark:
                    // Is this quotation mark escaped, or did we reach the end?
                    if escaping {
                        try nextScalar()
                        if scalar == FileConstants.quotationMark {
                            strBuilder.append(FileConstants.quotationMark)
                            try nextScalar()
                        } else {
                            break outerLoop
                        }
                    } else {
                        strBuilder.append(FileConstants.quotationMark)
                        try nextScalar()
                    }
                default:
                    strBuilder.append(scalar)
                    try nextScalar()
                }
            } while true // We only manually break the loop.
        } catch DeserializationError.EndOfFile {
            // This is ok if we are not escaping.
            endOfFile = true
            if escaping {
                throw DeserializationError.EndOfFile
            }
        }
        
        if parseTypes && !processingHeader {
            return (convertValue(string: strBuilder), endOfFile)
        } else {
            return (.string(strBuilder), endOfFile)
        }
    }
    
    /// Parses a string into an object if possible.
    private func convertValue(string: String) -> Node {
        
        if string == (capitalizeConstants ? CSVConstants.trueValue.uppercased() : CSVConstants.trueValue) {
            return .bool(true)
        } else if string == (capitalizeConstants ? CSVConstants.falseValue.uppercased() : CSVConstants.falseValue) {
            return .bool(false)
        } else if string == (capitalizeConstants ? CSVConstants.nullValue.uppercased() : CSVConstants.nullValue) {
            return .null
        } else if string.characters.count > 0{
            return parseNumberIfPossible(string: string)
        } else {
            return .null
        }
    }
    
    /// Converts a string to a number if possible. Otherwise it returns a string.
    /// - note: This should be kept similar to the JSON implementation.
    private func parseNumberIfPossible(string: String) -> Node {
        
        // Use a localized generator
        var nGenerator = string.unicodeScalars.makeIterator()
        var nScalar: UnicodeScalar = nGenerator.next()!
        
        var isNegative = false
        var hasDecimal = false
        var hasDigits = false
        var hasExponent = false
        var positiveExponent = false
        var exponent = 0
        var integer: UInt64 = 0
        var decimal: Int64 = 0
        var divisor: Double = 10
        
        outerLoop: repeat {
            switch nScalar {
            case FileConstants.digitScalars.first!...FileConstants.digitScalars.last!:
                // We started with numbers.
                hasDigits = true
                // Process differently wether or not the number is a decimal.
                if hasDecimal {
                    decimal *= 10
                    decimal += Int64(nScalar.value - FileConstants.zeroScalar.value)
                    divisor *= 10
                } else {
                    integer *= 10
                    integer += UInt64(nScalar.value - FileConstants.zeroScalar.value)
                }
                
                if let newScalar = nGenerator.next() {
                    nScalar = newScalar
                } else {
                    break outerLoop
                }
            case FileConstants.negativeScalar:
                // A number should only be marked negative once.
                if hasDigits || hasDecimal || hasExponent || isNegative {
                    return .string(string)
                } else {
                    isNegative = true
                }
                
                if let newScalar = nGenerator.next() {
                    nScalar = newScalar
                } else {
                    break outerLoop
                }
            case FileConstants.decimalScalar:
                // A number should only have one decimal place.
                if hasDecimal {
                    return .string(string)
                } else {
                    hasDecimal = true
                }
                
                if let newScalar = nGenerator.next() {
                    nScalar = newScalar
                } else {
                    break outerLoop
                }
            case CSVConstants.exponentLowercaseScalar, CSVConstants.exponentUppercaseScalar:
                // A number can't have two exponents.
                if hasExponent {
                    return .string(string)
                } else {
                    hasExponent = true
                }
                
                if let newScalar = nGenerator.next() {
                    nScalar = newScalar
                } else {
                    break outerLoop
                }
                
                // Determine if the exponenet is positive or negative.
                switch nScalar {
                case FileConstants.digitScalars.first!...FileConstants.digitScalars.last!:
                    positiveExponent = true
                case FileConstants.positiveScalar:
                    positiveExponent = true
                    
                    if let newScalar = nGenerator.next() {
                        nScalar = newScalar
                    } else {
                        break outerLoop
                    }
                case FileConstants.negativeScalar:
                    positiveExponent = false
                    if let newScalar = nGenerator.next() {
                        nScalar = newScalar
                    } else {
                        break outerLoop
                    }
                default:
                    return .string(string)
                }
                // Iterate over the numbers in the exponent.
                exponentLoop: repeat {
                    if nScalar.value >= FileConstants.zeroScalar.value && nScalar.value <= FileConstants.digitScalars.last?.value {
                        exponent *= 10
                        exponent += Int(nScalar.value - FileConstants.zeroScalar.value)
                        
                        if let newScalar = nGenerator.next() {
                            nScalar = newScalar
                        } else {
                            break outerLoop
                        }
                    } else {
                        break exponentLoop
                    }
                } while true // We only manually break the loop.
            default:
                break outerLoop
            }
        } while true // We only manually break the loop.
        
        // If there are no digits, there is no number.
        if !hasDigits {
            return .string(string)
        }
        
        // Create the number
        // TODO: Handle numbers too large and too small for standard types.
        // TODO: Handle numbers with exponents that become an integer.
        let sign = isNegative ? -1 : 1
        if hasDecimal || hasExponent {
            // TODO: Need to find a way that maintains decimal percision.
            // String conversion? What is the speed of that?
            // Perhaps have NumberValue always be (mantissa, exponent, sign), and convert to decimal on demand?
            divisor /= 10
            var number = Double(sign) * (Double(integer) + (Double(decimal) / divisor))
            if hasExponent {
                if positiveExponent {
                    for _ in 1...exponent {
                        number *= Double(10)
                    }
                } else {
                    for _ in 1...exponent {
                        number /= Double(10)
                    }
                }
            }
            return .number(number)
        } else {
            var number: Int64
            if isNegative {
                if integer > UInt64(Int64.max) + 1 {
                    return .string(string)
                } else if integer == UInt64(Int64.max) + 1 {
                    number = Int64.min
                } else {
                    number = Int64(integer) * -1
                }
            } else {
                if integer > UInt64(Int64.max) {
                    return .string(string)
                } else {
                    number = Int64(integer)
                }
            }
            return .number(Double(number))
        }
    }
}



