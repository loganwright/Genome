//
//  JSONDeserializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/11/16.
//
//

@_exported import Genome

public class JSONDeserializer: Deserializer {
    
    //---------------------------------
    // MARK: Properties
    //---------------------------------
    
    /// Protects against line feed hacks.
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
                let value = try parseValue()
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
                    return value
                }
            } catch DeserializationError.EndOfFile {
                throw DeserializationError.EmptyInput
            }
        }
    }
    
    // MARK: - Main Parse Loop
    
    /// Determines the type of node and parses it accordingly.
    private func parseValue() throws -> Node {
        try skipToNextToken()
        
        switch scalar {
        case FileConstants.leftCurlyBracket:
            return try parseObject()
        case FileConstants.leftSquareBracket:
            return try parseArray()
        case FileConstants.quotationMark:
            return try parseString()
        case JSONConstants.trueValue.unicodeScalars.first!, JSONConstants.falseValue.unicodeScalars.first!:
            return try parseBoolean()
        case JSONConstants.nullValue.unicodeScalars.first!:
            return try parseNull()
        case FileConstants.digitScalars.first!...FileConstants.digitScalars.last!, FileConstants.negativeScalar, FileConstants.decimalScalar:
            return try parseNumber()
        default:
            throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
        }
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
    
    /**
     Retreives the next scalars and returns an array.
     - parameter count: The number of scalars to retreive.
     - returns: An array of scalars.
     */
    private func nextScalars(count: UInt) throws -> [UnicodeScalar] {
        var values: [UnicodeScalar] = []
        values.reserveCapacity(Int(count))
        for _ in 0..<count {
            try nextScalar()
            values.append(scalar)
        }
        return values
    }
    
    // MARK: - Object Parsing
    
    /// Parses object data.
    private func parseObject() throws -> Node {
        // Check to see that the next token is an opening curly brace.
        if scalar != FileConstants.leftCurlyBracket {
            throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
        }
        // Skip the opening curly brace.
        try nextScalar()
        
        // Object storage.
        var dict = [String : Node]()
        
        // Check to see if we have an empty object.
        if scalar == FileConstants.rightCurlyBracket {
            return Node.object(dict)
        }
        
        // Iterate over the objects.
        outerLoop: repeat {
            // Skip whitespace.
            if scalar == FileConstants.tabCharacter || scalar == FileConstants.lineFeed || scalar == FileConstants.carriageReturn || scalar == FileConstants.space {
                try skipToNextToken()
            }
            // Get the key.
            let jsonString = try parseString()
            // Skip the end quotation character.
            try nextScalar()
            
            // Skip whitespace.
            if scalar == FileConstants.tabCharacter || scalar == FileConstants.lineFeed || scalar == FileConstants.carriageReturn || scalar == FileConstants.space {
                try skipToNextToken()
            }
            
            // If the next character is not a colon, we do not have a valid object.
            if scalar != FileConstants.colon {
                throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
            }
            // Skip the ':'.
            try nextScalar()
            
            // Skip the closing character for all values except number, which doesn't have one.
            let value = try parseValue()
            switch value {
            case .number:
                break
            default:
                try nextScalar()
            }
            
            // Skip to the next token.
            if scalar == FileConstants.tabCharacter || scalar == FileConstants.lineFeed || scalar == FileConstants.carriageReturn || scalar == FileConstants.space {
                try skipToNextToken()
            }
            
            // Add the object to the dictionary.
            let key = jsonString.string!
            dict[key] = value
            
            // Check to see if we reached the end of the object, or if there is another key/value pair.
            switch scalar {
            case FileConstants.rightCurlyBracket:
                break outerLoop
            case FileConstants.comma:
                try nextScalar()
            default:
                throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
            }
            
        } while true // We only manually break the loop.
        
        return Node.object(dict)
    }
    
    /// Parses array data
    private func parseArray() throws -> Node {
        // Check to see that the next token is an opening square bracket.
        if scalar != FileConstants.leftSquareBracket {
            throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
        }
        // Skip the opening bracket
        try nextScalar()
        
        // Array storage
        var arr: [Node] = []
        
        // Check to see if the array is empty.
        if scalar == FileConstants.rightSquareBracket {
            // Empty array
            return .array(arr)
        }
        
        // Iterate over the objects.
        outerLoop: repeat {
            // Retreive the next value.
            let value = try parseValue()
            arr.append(value)
            
            // Skip the closing character for all values except number, which doesn't have one.
            switch value {
            case .number:
                break
            default:
                try nextScalar()
            }
            
            // Skip whitespace.
            if scalar == FileConstants.tabCharacter || scalar == FileConstants.lineFeed || scalar == FileConstants.carriageReturn || scalar == FileConstants.space {
                try skipToNextToken()
            }
            
            // Check to see if we reached the end of the array, or if there is another value.
            switch scalar {
            case FileConstants.rightSquareBracket:
                break outerLoop
            case FileConstants.comma:
                try nextScalar()
            default:
                throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
            }
        } while true // We only manually break the loop.
        
        return .array(arr)
    }
    
    /// Parses string data
    private func parseString() throws -> Node {
        // Check to see that the next token is a quotation mark.
        if scalar != FileConstants.quotationMark {
            throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
        }
        // Skip opening quotation
        try nextScalar()
        
        // String storage
        var strBuilder = ""
        // Whether or not the next character will be escaped.
        var escaping = false
        
        // Iterate over the objects.
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
            case FileConstants.quotationMark:
                // Is this quotation mark escaped, or did we reach the end?
                if escaping {
                    strBuilder.append(FileConstants.quotationMark)
                    escaping = false
                    try nextScalar()
                } else {
                    break outerLoop
                }
            default:
                // Continue parsing the string.
                if escaping {
                    // Handle all the different escape characters
                    if let s = JSONConstants.unescapeMapping[scalar] {
                        strBuilder.append(s)
                        try nextScalar()
                    } else if scalar == "u".unicodeScalars.first! {
                        // Handle unicode
                        let escapedUnicodeValue = try nextUnicodeEscape()
                        strBuilder.append(UnicodeScalar(escapedUnicodeValue))
                        try nextScalar()
                    }
                    escaping = false
                } else {
                    // Simple append
                    strBuilder.append(scalar)
                    try nextScalar()
                }
            }
        } while true // We only manually break the loop.
        
        return .string(strBuilder)
    }
    
    /// Parses a unicode character.
    private func nextUnicodeEscape() throws -> UInt32 {
        // Check to see that the token is a unicode mark.
        if scalar != "u".unicodeScalars.first! {
            throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
        }
        
        // The read character.
        var readScalar = UInt32(0)
        // Iterate over the next three characters
        for _ in 0...3 {
            readScalar = readScalar * 16
            try nextScalar()
            
            // Convert from hex.
            if ("0".unicodeScalars.first!..."9".unicodeScalars.first!).contains(scalar) {
                readScalar = readScalar + UInt32(scalar.value - "0".unicodeScalars.first!.value)
            } else if ("a".unicodeScalars.first!..."f".unicodeScalars.first!).contains(scalar) {
                let aScalarVal = "a".unicodeScalars.first!.value
                let hexVal = scalar.value - aScalarVal
                let hexScalarVal = hexVal + 10
                readScalar = readScalar + hexScalarVal
            } else if ("A".unicodeScalars.first!..."F".unicodeScalars.first!).contains(scalar) {
                let aScalarVal = "A".unicodeScalars.first!.value
                let hexVal = scalar.value - aScalarVal
                let hexScalarVal = hexVal + 10
                readScalar = readScalar + hexScalarVal
            } else {
                throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
            }
        }
        
        if readScalar >= 0xD800 && readScalar <= 0xDBFF {
            // UTF-16 surrogate pair
            // The next character MUST be the other half of the surrogate pair
            // Otherwise it's a unicode error
            do {
                try nextScalar()
                if scalar != FileConstants.reverseSolidus {
                    throw DeserializationError.InvalidUnicode
                }
                try nextScalar()
                let secondScalar = try nextUnicodeEscape()
                if secondScalar < 0xDC00 || secondScalar > 0xDFFF {
                    throw DeserializationError.InvalidUnicode
                }
                let actualScalarPartOne = (readScalar - 0xD800) * 0x400
                let actualScalarPartTwo = (secondScalar - 0xDC00) + 0x10000
                let actualScalar = actualScalarPartOne + actualScalarPartTwo
                return actualScalar
            } catch DeserializationError.UnexpectedCharacter {
                throw DeserializationError.InvalidUnicode
            }
        }
        
        return readScalar
    }
    
    /// Parses a number
    private func parseNumber() throws -> Node {
        var isNegative = false
        var hasDecimal = false
        var hasDigits = false
        var hasExponent = false
        var positiveExponent = false
        var exponent = 0
        var integer: UInt64 = 0
        var decimal: Int64 = 0
        var divisor: Double = 10
        let lineNumAtStart = lineNumber
        let charNumAtStart = characterNumber
        
        do {
            outerLoop: repeat {
                switch scalar {
                case FileConstants.digitScalars.first!...FileConstants.digitScalars.last!:
                    // We started with numbers.
                    hasDigits = true
                    // Process differently wether or not the number is a decimal.
                    if hasDecimal {
                        decimal *= 10
                        decimal += Int64(scalar.value - FileConstants.zeroScalar.value)
                        divisor *= 10
                    } else {
                        integer *= 10
                        integer += UInt64(scalar.value - FileConstants.zeroScalar.value)
                    }
                    try nextScalar()
                case FileConstants.negativeScalar:
                    // A number should only be marked negative once.
                    if hasDigits || hasDecimal || hasExponent || isNegative {
                        throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
                    } else {
                        isNegative = true
                    }
                    try nextScalar()
                case FileConstants.decimalScalar:
                    // A number should only have one decimal place.
                    if hasDecimal {
                        throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
                    } else {
                        hasDecimal = true
                    }
                    try nextScalar()
                case JSONConstants.exponentLowercaseScalar, JSONConstants.exponentUppercaseScalar:
                    // A number can't have two exponents.
                    if hasExponent {
                        throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
                    } else {
                        hasExponent = true
                    }
                    try nextScalar()
                    // Determine if the exponenet is positive or negative.
                    switch scalar {
                    case FileConstants.digitScalars.first!...FileConstants.digitScalars.last!:
                        positiveExponent = true
                    case FileConstants.positiveScalar:
                        positiveExponent = true
                        try nextScalar()
                    case FileConstants.negativeScalar:
                        positiveExponent = false
                        try nextScalar()
                    default:
                        throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
                    }
                    // Iterate over the numbers in the exponent.
                    exponentLoop: repeat {
                        if scalar.value >= FileConstants.zeroScalar.value && scalar.value <= FileConstants.digitScalars.last?.value {
                            exponent *= 10
                            exponent += Int(scalar.value - FileConstants.zeroScalar.value)
                            try nextScalar()
                        } else {
                            break exponentLoop
                        }
                    } while true // We only manually break the loop.
                default:
                    break outerLoop
                }
            } while true // We only manually break the loop.
            
        } catch DeserializationError.EndOfFile {
            // This is fine
        }
        
        // If there are no digits, there is no number.
        if !hasDigits {
            throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
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
                    throw DeserializationError.InvalidNumber(lineNumber: lineNumAtStart, characterNumber: charNumAtStart)
                } else if integer == UInt64(Int64.max) + 1 {
                    number = Int64.min
                } else {
                    number = Int64(integer) * -1
                }
            } else {
                if integer > UInt64(Int64.max) {
                    throw DeserializationError.InvalidNumber(lineNumber: lineNumAtStart, characterNumber: charNumAtStart)
                } else {
                    number = Int64(integer)
                }
            }
            return .number(Double(number))
        }
    }
    
    /// Parses a boolean object
    private func parseBoolean() throws -> Node {
        var expectedWord: String.UnicodeScalarView
        var expectedBool: Bool
        let lineNumAtStart = lineNumber
        let charNumAtStart = characterNumber
        
        // Which bool is it?
        if scalar == JSONConstants.trueValue.unicodeScalars.first! {
            expectedWord = JSONConstants.trueValue.unicodeScalars
            expectedBool = true
        } else if scalar == JSONConstants.falseValue.unicodeScalars.first! {
            expectedWord = JSONConstants.falseValue.unicodeScalars
            expectedBool = false
        } else {
            throw DeserializationError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: characterNumber)
        }
        
        // Check to see if the full boolean text is there.
        do {
            let word = try [scalar] + nextScalars(count: UInt(expectedWord.count - 1))
            if word != [UnicodeScalar](expectedWord) {
                throw DeserializationError.UnexpectedKeyword(lineNumber: lineNumAtStart, characterNumber: charNumAtStart)
            }
        } catch DeserializationError.EndOfFile {
            throw DeserializationError.UnexpectedKeyword(lineNumber: lineNumAtStart, characterNumber: charNumAtStart)
        }
        return .bool(expectedBool)
    }
    
    func parseNull() throws -> Node {
        let word = try [scalar] + nextScalars(count: 3)
        if word != [UnicodeScalar](JSONConstants.nullValue.unicodeScalars) {
            throw DeserializationError.UnexpectedKeyword(lineNumber: lineNumber, characterNumber: characterNumber-4)
        }
        return .null
    }
    
}
