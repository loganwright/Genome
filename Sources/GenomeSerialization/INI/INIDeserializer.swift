//
//  INIDeserializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/13/16.
//
//

@_exported import Genome

/**
 Deserializes INI data into a `Node` representation.
 
 - note: This is a basic parser that assumes the following:
 - Comments will always begin at the start of a line, and begin with a semicolon.
 - Sections identifiers will start on a new line, and the only following characters after the close of a section identifier will be whitespace.
 - There will be one key-value pair per line. Keys and values cannot be multiple lines. Keys cannot contain whitespace characters.
 - Escaped characters will be allowed in keys. This can be easily changed if the oppisite should be enforced.
 - Any values with whitespace characters must be encased in double or single quotes. Line feeds and carrage returns must be escaped.
 */
public class INIDeserializer: Deserializer {
    
    //---------------------------------
    // MARK: Properties
    //---------------------------------
    
    /// The delimeter to use when creating sub-sections.
    /// - default: Period (`.`)
    public var sectionDelimiter: UnicodeScalar = FileConstants.decimalScalar
    
    /// The delimiter of an array of values other than whitespace.
    /// - note: This is to allow support of reading ini files that have comma (`,`) separators instead of just spaces.
    public var arrayDelimiter: UnicodeScalar?
    
    /// The delimiter between keys and values. Usually "`=`", but some ini files use: "`:`".
    /// - default: `=`
    public var keyValueDelimiter: UnicodeScalar = FileConstants.equalScalar
    
    /// Whether or not to attempt to parse the string values into other types.
    public var parseTypes: Bool = true
    
    /// Whether or not to read the constants "true", "false", and "null" as capitalized strings.
    public var capitalizeConstants: Bool = true
    
    /// Protects against line feeds messing up the line number.
    private var crlfHack: Bool = false
    
    //---------------------------------
    // MARK: Parsing
    //---------------------------------
    
    public override func parse(data: String.UnicodeScalarView) throws -> Node {
        try super.parse(data: data)
        do {
            do {
                /// Load the first scalar.
                try nextScalar()
                /// Parse the first value.
                let value = try parseLine()
                do {
                    try nextScalar()
                    if scalar == FileConstants.tabCharacter || scalar == FileConstants.lineFeed || scalar == FileConstants.carriageReturn || scalar == FileConstants.space {
                        // Skip to EOF or the next token
                        try skipToNextToken()
                        // If we get this far some token was found ...
                        throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
                    } else {
                        // There's some weird character at the end of the file...
                        throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
                    }
                } catch DeserializationError.EndOfFile {
                    return value.node
                }
            } catch DeserializationError.EndOfFile {
                throw DeserializationError.EmptyInput
            }
        }
    }
    
    // MARK: - Main Parse Loop
    
    private func parseLine(forSection: Bool = false) throws -> (node: Node, safeEndOfFile: Bool) {
        
        var section: [String: Node] = [:]
        var safeEndOfFile: Bool = false
        
        outerLoop: repeat {
            
            // If the next character is whitespace, continue to the first token.
            if scalar == FileConstants.tabCharacter || scalar == FileConstants.lineFeed || scalar == FileConstants.carriageReturn || scalar == FileConstants.space {
                do {
                    try skipToNextToken()
                } catch DeserializationError.EndOfFile {
                    safeEndOfFile = true
                    break outerLoop
                }
            }
            
            switch scalar {
            case FileConstants.leftSquareBracket:
                if forSection {
                    // If we are in a section, jump back to the root node.
                    break outerLoop
                } else {
                    // Get the section key path.
                    let keyPath = try parseSectionKeyPath()
                    // Skip the closing bracket
                    try nextScalar()
                    // Skip to the next token. (Force it here because in our implementation, only whitespace is allowed after a section declaration line.)
                    try skipToNextToken()
                    // Get the object associated with the key
                    let value = try parseLine(forSection: true)
                    // Set the object to its key path.
                    try setValue(value: value.node, toObject: &section, keyPath: keyPath)
                    if value.safeEndOfFile {
                        safeEndOfFile = true
                        break outerLoop
                    }
                }
                break
            case FileConstants.semicolon:
                // The beginning of a comment.
                do {
                    try parseComment()
                } catch DeserializationError.EndOfFile {
                    safeEndOfFile = true
                    break outerLoop
                }
                break
            default:
                // The beginning of a Key-value pair.
                let key = try parseKey()
                // Skip the delimiter
                try nextScalar()
                let value = try parseValue()
                section[key] = value.node
                if value.safeEndOfFile {
                    safeEndOfFile = true
                    break outerLoop
                }
                break
            }
            
        } while true // We only manually break the loop.
        
        return (.object(section), safeEndOfFile)
    }
    
    /// Skips whitespace until the next non-whitespace token is found.
    private func skipToNextToken() throws {
        
        // If the next character is not whitespace, it is unexpected.
        if scalar != FileConstants.tabCharacter && scalar != FileConstants.lineFeed && scalar != FileConstants.carriageReturn && scalar != FileConstants.space {
            throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
        }
        
        // Iterate over all whitespace characters until a new token is reached.
        while scalar == FileConstants.tabCharacter || scalar == FileConstants.lineFeed || scalar == FileConstants.carriageReturn || scalar == FileConstants.space {
            
            if scalar == FileConstants.carriageReturn || scalar == FileConstants.lineFeed {
                
                // End the CLRF hack.
                if crlfHack == true && scalar == FileConstants.lineFeed {
                    crlfHack = false
                    characterNumber = 0
                } else {
                    // Check to see if we are starting a series of
                    if (scalar == FileConstants.carriageReturn) {
                        crlfHack = true
                    }
                    // Add to the new line count.
                    lineNumber = lineNumber + 1
                    characterNumber = 0
                }
            }
            
            try nextScalar()
        }
    }
    
    /// Set a value to a given object, traversing a key path.
    private func setValue(value: Node, toObject: inout [String: Node], keyPath: [String]) throws {
        
        if keyPath.count == 1 {
            // Set the object to the dictionary.
            toObject[keyPath.first!] = value
            return
        } else if keyPath.count > 0 {
            
            // Create a new object if necessary.
            if toObject[keyPath.first!] == nil {
                toObject[keyPath.first!] = .object([:])
            }
            
            switch toObject[keyPath.first!]! {
            case .object:
                // Do nothing
                break
            default:
                // Replace the node with a dictionary
                toObject[keyPath.first!] = .object([:])
                break
            }
            
            guard case var .object(dictionary) = toObject[keyPath.first!]! else {
                // This should never happen.
                throw DeserializationError.Unknown
            }
            
            try setValue(value: value, toObject: &dictionary, keyPath: Array(keyPath.dropFirst(1)))
            toObject[keyPath.first!] = .object(dictionary)
            return
        }
        
        // This should also never happen.
        throw DeserializationError.Unknown
    }
    
    private func parseSectionKeyPath() throws -> [String] {
        // Check to see that the next token is an opening square bracket.
        if scalar != FileConstants.leftSquareBracket {
            throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
        }
        // Skip the opening square bracket.
        try nextScalar()
        
        // String storage
        var strBuilder = ""
        var keys: [String] = []
        
        // Whether or not the next character will be escaped. The escaping of characters in the section name is questionable
        var escaping = false
        
        // Iterate over the objects
        outerLoop: repeat {
            // First we should deal with the escape character and the terminating quote
            switch scalar {
            case FileConstants.reverseSolidus:
                // Escape character
                if escaping {
                    // Escaping the escape char
                    strBuilder.append(FileConstants.reverseSolidus)
                }
                escaping = !escaping
                try nextScalar()
                break
            case FileConstants.carriageReturn, FileConstants.lineFeed, FileConstants.tabCharacter, FileConstants.space:
                // These are not allowed in the section identifier.
                throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
            case sectionDelimiter:
                
                if escaping {
                    // Continue parsing the string.
                    if let s = INIConstants.unescapeMapping[scalar] {
                        if s == sectionDelimiter {
                            // New section
                            keys.append(strBuilder)
                            strBuilder = ""
                        } else {
                            // Not the section delimiter, append.
                            strBuilder.append(s)
                        }
                    } else {
                        // New section
                        keys.append(strBuilder)
                        strBuilder = ""
                    }
                    escaping = false
                } else {
                    // New section
                    keys.append(strBuilder)
                    strBuilder = ""
                }
                try nextScalar()
                break
            case FileConstants.rightSquareBracket:
                // End of the section.
                keys.append(strBuilder)
                strBuilder = ""
                break outerLoop
            default:
                // Continue parsing the string.
                if escaping {
                    // Handle all the different escape characters
                    if let s = INIConstants.unescapeMapping[scalar] {
                        strBuilder.append(s)
                    } else {
                        strBuilder.append(scalar)
                    }
                    escaping = false
                } else {
                    // Simple append
                    strBuilder.append(scalar)
                }
                try nextScalar()
                break
            }
        } while true // We only manually break the loop.
        
        return keys
    }
    
    private func parseComment() throws {
        // Iterate over the objects
        outerLoop: repeat {
            // First we should deal with the escape character and the terminating quote
            switch scalar {
            case FileConstants.carriageReturn, FileConstants.lineFeed:
                // End of the comment
                break outerLoop
            default:
                // Get the next character.
                try nextScalar()
            }
        } while true // We only manually break the loop.
    }
    
    private func parseKey() throws -> String {
        
        // Whether or not the next character will be escaped. The escaping of characters in the section name is questionable
        var escaping = false
        
        // Iterate over the key
        var key: String = ""
        outerLoop: repeat {
            switch scalar {
            case FileConstants.reverseSolidus:
                // Escape character
                if escaping {
                    // Escaping the escape char
                    key.append(FileConstants.reverseSolidus)
                }
                escaping = !escaping
                try nextScalar()
                break
            case FileConstants.carriageReturn, FileConstants.lineFeed, FileConstants.tabCharacter, FileConstants.space:
                // These characters are not allowed in the key.
                throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
            case keyValueDelimiter:
                // Continue parsing the string.
                if escaping {
                    // Handle all the different escape characters
                    if let s = INIConstants.unescapeMapping[scalar] {
                        key.append(s)
                    } else {
                        key.append(scalar)
                    }
                    try nextScalar()
                    escaping = false
                } else {
                    break outerLoop
                }
                break
            default:
                // Continue parsing the key.
                if escaping {
                    // Handle all the different escape characters
                    if let s = INIConstants.unescapeMapping[scalar] {
                        key.append(s)
                    } else {
                        key.append(scalar)
                    }
                    escaping = false
                } else {
                    // Simple append
                    key.append(scalar)
                }
                try nextScalar()
                break
            }
        } while true // We only manually break out of the loop.
        
        return key
    }
    
    private func parseValue() throws -> (node: Node, safeEndOfFile: Bool) {
        // Whether or not the next character will be escaped.
        var escaping = false
        var singleQuoteContained = false
        var doubleQuoteContained = false
        var firstCharacterParsed = false
        // End of file
        var safeEndOfFile = false
        
        // Iterate over the value. Start with an empty string, append more strings if we have an array.
        var values: [String] = [""]
        do {
            outerLoop: repeat {
                switch scalar {
                case FileConstants.reverseSolidus:
                    // Escape character
                    if escaping {
                        // Escaping the escape char
                        values[values.count - 1].append(FileConstants.reverseSolidus)
                    }
                    escaping = !escaping
                    try nextScalar()
                    break
                case FileConstants.quotationMark, FileConstants.apostropheMark:
                    if escaping {
                        // Append the quote
                        values[values.count - 1].append(scalar)
                        escaping = false
                    } else if !firstCharacterParsed {
                        // We are quote contained
                        if scalar == FileConstants.quotationMark {
                            doubleQuoteContained = true
                        } else {
                            singleQuoteContained = true
                        }
                    } else {
                        // Is it the end quote?
                        if scalar == FileConstants.quotationMark && doubleQuoteContained {
                            singleQuoteContained = false
                        } else if scalar == FileConstants.apostropheMark && singleQuoteContained {
                            doubleQuoteContained = false
                        } else {
                            values[values.count - 1].append(scalar)
                        }
                    }
                    try nextScalar()
                    break
                case FileConstants.carriageReturn, FileConstants.lineFeed:
                    // End of the value.
                    if !singleQuoteContained || !doubleQuoteContained {
                        break outerLoop
                    }
                    // If we are quote contained, these values are not allowed.
                    throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
                case FileConstants.space:
                    // Continue parsing the string.
                    if escaping {
                        // Handle all the different escape characters
                        if let s = INIConstants.unescapeMapping[scalar] {
                            values[values.count - 1].append(s)
                        } else {
                            values[values.count - 1].append(scalar)
                        }
                        escaping = false
                    } else if singleQuoteContained || doubleQuoteContained {
                        // Inside quotes, append the space.
                        values[values.count - 1].append(scalar)
                    } else {
                        // Append a new array element.
                        values.append("")
                    }
                    try nextScalar()
                    break
                default:
                    // Continue parsing the key.
                    if escaping {
                        // Handle all the different escape characters
                        if let s = INIConstants.unescapeMapping[scalar] {
                            values[values.count - 1].append(s)
                        } else {
                            values[values.count - 1].append(scalar)
                        }
                        escaping = false
                    } else {
                        // Simple append
                        values[values.count - 1].append(scalar)
                    }
                    try nextScalar()
                    break
                }
                firstCharacterParsed = true
            } while true // We only manually break out of the loop.
        } catch DeserializationError.EndOfFile {
            // This is ok if we are not escaping.
            safeEndOfFile = true
            if escaping {
                throw DeserializationError.EndOfFile
            }
        }
        
        if values.count == 1 {
            // Get the string.
            let string = values[0]
            // Is it empty
            if string.characters.count == 0 {
                return (.null, safeEndOfFile)
            }
            
            // Parse the string if necessary.
            if parseTypes {
                return (convertValue(string: string), safeEndOfFile)
            } else {
                return (.string(string), safeEndOfFile)
            }
        } else {
            return (.array(values.map({
                // Parse the string if necessary.
                if parseTypes {
                    return convertValue(string: $0)
                } else {
                    return .string($0)
                }
            })), safeEndOfFile)
        }
    }
    
    /// Parses a string into an object if possible.
    private func convertValue(string: String) -> Node {
        
        if string == (capitalizeConstants ? INIConstants.trueValue.uppercased() : CSVConstants.trueValue) {
            return .bool(true)
        } else if string == (capitalizeConstants ? INIConstants.falseValue.uppercased() : CSVConstants.falseValue) {
            return .bool(false)
        } else if string == (capitalizeConstants ? INIConstants.nullValue.uppercased() : CSVConstants.nullValue) {
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

