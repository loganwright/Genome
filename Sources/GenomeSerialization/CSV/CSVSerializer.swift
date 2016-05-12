//
//  CSVSerializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/9/16.
//
//

@_exported import Genome
import Foundation

/**
 Serializes a `Node` array value into a CSV file acoording to the specification: [RFC4180](https://tools.ietf.org/html/rfc4180) with the option of changing the delimeter.
 */
public class CSVSerializer: Serializer {
    
    //---------------------------------
    // MARK: Properties
    //---------------------------------
    
    /// The delimeter to use when separating values.
    /// - default: Comma (`,`)
    public var delimeter: UnicodeScalar = FileConstants.comma
    
    /// Whether or not to include null values as the string null. If true, the output will be "null", if false the field will be output as empty.
    public var outputNull: Bool = false
    
    /// Whether or not to output the constants "true", "false", and "null" as capitalized strings.
    public var capitalizeConstants: Bool = false
    
    /// Whether or not the headers were preset.
    /// - default: `false`
    /// - note: If preset, and the root node is an array of objects, the headers will be generated from the keys of the first node. Otherwise only the specified headers will be used.
    private let presetHeaders: Bool
    
    /// The header values.
    private var header: [String] = []
    
    //---------------------------------
    // MARK: Initalization
    //---------------------------------
    
    override init(node: Node) {
        presetHeaders = false
        super.init(node: node)
    }
    
    /**
     Initalize the serializer with a node, a delimeter.
     - parameter node: The root node to serialize.
     - parameter delimeter: The delimeter to use to separate values.
     */
    init(node: Node, delimeter: UnicodeScalar) {
        presetHeaders = false
        self.delimeter = delimeter
        super.init(node: node)
    }
    
    /**
     Initalize the serializer with a node, a delimeter.
     - parameter node: The root node to serialize.
     - parameter header: The header keys to use when parsing objects.
     */
    init(node: Node, header: [String]) {
        presetHeaders = true
        self.header = header
        super.init(node: node)
    }
    
    /**
     Initalize the serializer with a node, a delimeter, and a header.
     - parameter node: The root node to serialize.
     - parameter delimeter: The delimeter to use to separate values.
     - parameter header: The header keys to use when parsing objects.
     - note: Only values listed in the provided header will be included.
     */
    init(node: Node, delimeter: UnicodeScalar, header: [String]) {
        self.delimeter = delimeter
        self.header = header
        presetHeaders = true
        super.init(node: node)
    }
    
    //---------------------------------
    // MARK: Parsing
    //---------------------------------
    
    override func parse() throws -> String {
        // The only valid root node is an array.
        switch rootNode {
        case let .array(array):
            try parseRoot(array: array)
            return output
        default:
            throw SerializationError.UnsupportedNodeType(reason: "The root node is expected to be an array.")
        }
    }
    
    /**
     Parses the root node that will become CSV data.
     - parameter array: The root node that will be parsed into CSV data.
     - throws: A `SerializationError` if one occurs.
     */
    private func parseRoot(array: [Node]) throws {
        // Check to see if the array is empty
        if array.count == 0 {
            throw SerializationError.EmptyInput
        }
        
        // Either we allow objects, or no objects.
        let objectBased: Bool
        switch array.first! {
        case .object:
            objectBased = true
        default:
            objectBased = false
        }
        
        // Iterate over the root array.
        var i: Int = 0
        for node in array {
            if objectBased {
                guard case let .object(object) = node else {
                    throw SerializationError.UnsupportedNodeType(reason: "The child nodes are expected to be objects.")
                }
                try parse(object: object)
            } else {
                switch node {
                case .object:
                    throw SerializationError.UnsupportedNodeType(reason: "The child nodes are expected to non-objects.")
                case let .array(array):
                    try parse(array: array)
                    break
                case .null:
                    parseNull()
                    break
                case let .string(string):
                    parse(string: string)
                    break
                case let .number(number):
                    parse(number: number)
                    break
                case let .bool(boolean):
                    parse(boolean: boolean)
                    break
                }
            }
            // Append a new line if necessary.
            i += 1
            if i != array.count {
                output.append(lineEndings.rawValue)
            }
        }
    }
    
    /// Determines the type of node and parses it accordingly.
    private func parse(value: Node?) throws {
        if let value = value {
            switch value {
            case .null:
                break
            case let .string(string):
                parse(string: string)
                break
            case let .number(number):
                parse(number: number)
                break
            case let .bool(boolean):
                parse(boolean: boolean)
                break
            default:
                throw SerializationError.UnsupportedNodeType(reason: "The child's values are not allowed to be arrays or objects.")
            }
        }
    }
    
    /// Parses an array.
    private func parse(array: [Node]) throws {
        var i: Int = 0
        for node in array {
            try parse(value: node)
            // Append a delimeter if necessary
            i += 1
            if i != array.count {
                output.append(delimeter)
            }
        }
    }
    
    /// Parses an object.
    private func parse(object: [String: Node]) throws {
        // Parse the keys in the header first.
        if !presetHeaders && header.count == 0 {
            var i: Int = 0
            for pair in object {
                header.append(pair.0)
                output.append(pair.0)
                
                i += 1
                if i != object.count {
                    output.append(delimeter)
                }
            }
            output.append(lineEndings.rawValue)
        }
        
        // Parse all values.
        var i: Int = 0
        for key in header {
            i += 1
            // Append only if we haven't added the object again.
            try parse(value: object[key])
            
            if i != header.count {
                output.append(delimeter)
            }
        }
    }
    
    /// Parses a string.
    private func parse(string: String) {
        // Escape the quotes in the string if necessary.
        
        if string.contains("\"") {
            // Escape
            output.append("\"\(string.replacingOccurrences(of: "\"", with: "\"\""))\"")
        } else {
            output.append(string)
        }
    }
    
    /// Parses a number.
    private func parse(number: Double) {
        // Check to see if we have an integer
        if number == Double(Int(number)) {
            output.append(String(Int(number)))
        } else {
            output.append(String(number))
        }
    }
    
    /// Parses a boolean.
    private func parse(boolean: Bool) {
        if !capitalizeConstants {
            output.append(boolean ? CSVConstants.trueValue : CSVConstants.falseValue)
        } else {
            output.append(boolean ? CSVConstants.trueValue.uppercased() : CSVConstants.falseValue.uppercased())
        }
    }
    
    /// Parses null.
    private func parseNull() {
        if outputNull {
            if !capitalizeConstants {
                output.append(CSVConstants.nullValue)
            } else {
                output.append(CSVConstants.nullValue.uppercased())
            }
        }
    }
}