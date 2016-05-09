//
//  CSVSerializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/9/16.
//
//

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
    
    override func parse() throws -> String? {
        // If the headers were preset, output them.
        if presetHeaders {
            serializationDelegate.serializerSerializedData(data: header.joined(separator: ","))
            serializationDelegate.serializerSerializedData(data: lineEndings.rawValue)
        }
        // The only valid root node is an array.
        switch rootNode {
        case let .array(array):
            try parseRootArray(array: array)
            return (serializationDelegate as? SerializerConcatenate)?.output
        default:
            throw SerializationError.UnsupportedNodeType(reason: "The root node is expected to be an array.")
        }
    }
    
    private func parseRootArray(array: [Node]) throws {
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
                try parseObject(object: object)
            } else {
                switch node {
                case .object:
                    throw SerializationError.UnsupportedNodeType(reason: "The child nodes are expected to be arrays.")
                case let .array(array):
                    try parseArray(array: array)
                    break
                case .null:
                    break
                case let .string(string):
                    parseString(string: string)
                    break
                case let .number(number):
                    parseNumber(number: number)
                    break
                case let .bool(boolean):
                    parseBoolean(boolean: boolean)
                    break
                }
            }
            // Append a new line if necessary.
            i += 1
            if i != array.count {
                serializationDelegate.serializerSerializedData(data: lineEndings.rawValue)
            }
        }
        serializationDelegate.serializerFinished()
    }
    
    private func parseArray(array: [Node]) throws {
        var i: Int = 0
        for node in array {
            try parseValue(value: node)
            // Append a delimeter if necessary
            i += 1
            if i != array.count {
                serializationDelegate.serializerSerializedData(data: String(delimeter))
            }
        }
    }
    
    private func parseObject(object: [String: Node]) throws {
        // Parse the keys in the header first.
        if !presetHeaders && header.count == 0 {
            var i: Int = 0
            for pair in object {
                header.append(pair.0)
                serializationDelegate.serializerSerializedData(data: pair.0)
                
                i += 1
                if i != object.count {
                    serializationDelegate.serializerSerializedData(data: String(delimeter))
                }
            }
            serializationDelegate.serializerSerializedData(data: lineEndings.rawValue)
        }
        
        // Parse all values.
        var i: Int = 0
        for key in header {
            i += 1
            // Append only if we haven't added the object again.
            try parseValue(value: object[key])
            
            if i != header.count {
                serializationDelegate.serializerSerializedData(data: String(delimeter))
            }
        }
    }
    
    private func parseValue(value: Node?) throws {
        if let value = value {
            switch value {
            case .null:
                break
            case let .string(string):
                parseString(string: string)
                break
            case let .number(number):
                parseNumber(number: number)
                break
            case let .bool(boolean):
                parseBoolean(boolean: boolean)
                break
            default:
                throw SerializationError.UnsupportedNodeType(reason: "The child's values are not allowed to be arrays or objects.")
            }
        }
    }
    
    private func parseString(string: String) {
        // Escape the quotes in the string if necessary.
        if string.contains("\"") {
            // Escape
            serializationDelegate.serializerSerializedData(data: "\"\(string.replacingOccurrences(of: "\"", with: "\"\""))\"")
        } else {
            serializationDelegate.serializerSerializedData(data: string)
        }
    }
    
    private func parseNumber(number: Double) {
        // Check to see if we have an integer
        if number == Double(Int(number)) {
            serializationDelegate.serializerSerializedData(data: String(Int(number)))
        } else {
            serializationDelegate.serializerSerializedData(data: String(number))
        }
    }
    
    private func parseBoolean(boolean: Bool) {
        serializationDelegate.serializerSerializedData(data: boolean ? CSVConstants.trueValue : CSVConstants.falseValue)
    }
}