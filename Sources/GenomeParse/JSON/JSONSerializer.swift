//
//  JSONSerializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/9/16.
//
//

/**
 Serializes a `Node` into a JSON file acoording to the specification: [RFC7159](https://tools.ietf.org/html/rfc7159) with the option of changing the delimeter.
 */
public class JSONSerializer: Serializer {
    
    //---------------------------------
    // MARK: Properties
    //---------------------------------
    
    /// If true, whitespace will be inserted into the output to make it easer to read.
    let prettyPrint: Bool
    
    //---------------------------------
    // MARK: Initalization
    //---------------------------------
    
    public override init(node: Node) {
        prettyPrint = false
        super.init(node: node)
    }
    
    /**
     Initalizes a deserializer with the given node.
     - parameter node: The node to parse into data.
     - parameter prettyPrint: Whether or not to insert whitespace to make the output easier to read.
     - returns: A new deserializer object that will parse the given node.
     */
    public init(node: Node, prettyPrint: Bool) {
        self.prettyPrint = prettyPrint
        super.init(node: node)
    }
    
    //---------------------------------
    // MARK: Parsing
    //---------------------------------
    
    override func parse() throws -> String? {
        // Run the serialzers coresponding to the `prettyPrint` setting.
        if !prettyPrint {
            switch rootNode {
            case let .array(array):
                parse(array: array)
            case let .object(object):
                parse(object: object)
            default:
                throw SerializationError.UnsupportedNodeType(reason: "The root node is expected to be an array or object.")
            }
        } else {
            switch rootNode {
            case let .array(array):
                parse(array: array, indentLevel: 0)
            case let .object(object):
                parse(object: object, indentLevel: 0)
            default:
                throw SerializationError.UnsupportedNodeType(reason: "The root node is expected to be an array or object.")
            }
        }
        return output
    }
    
    /// Determines the type of node and parses it accordingly.
    private func parseValue(node: Node) {
        switch node {
        case .null:
            parseNull()
            break
        case let .bool(boolean):
            parse(boolean: boolean)
            break
        case let .number(number):
            parse(number: number)
            break
        case let .string(string):
            parse(string: string)
            break
        case let .object(object):
            parse(object: object)
        case let .array(array):
            parse(array: array)
        }
    }
    
    /// Determines the type of node and parses it accordingly with pretty printing.
    private func parse(node: Node, indentLevel: Int) {
        switch node {
        case .null:
            parseNull()
            break
        case let .bool(boolean):
            parse(boolean: boolean)
            break
        case let .number(number):
            parse(number: number)
            break
        case let .string(string):
            parse(string: string)
            break
        case let .object(object):
            parse(object: object, indentLevel: indentLevel)
        case let .array(array):
            parse(array: array, indentLevel: indentLevel)
        }
    }
    
    /// Parses objects.
    private func parse(object: [String: Node]) {
        // Open the object
        output.append(FileConstants.leftCurlyBracket)
        // Iterate over all keys and values.
        var i: Int = 0
        for (key, value) in object {
            // Append the key, then the value.
            output.append(escape(string: key) + String(FileConstants.colon))
            parseValue(node: value)
            // Add a comma if necessary.
            i += 1
            if i != object.count {
                output.append(FileConstants.comma)
            }
        }
        // Close the object
        output.append(FileConstants.rightCurlyBracket)
    }
    
    /// Parses objects with pretty printing.
    private func parse(object: [String: Node], indentLevel: Int) {
        // Open the object
        output.append(String(FileConstants.leftCurlyBracket) + lineEndings.rawValue)
        // Pretty print
        let indent = indentString(level: indentLevel)
        // Iterate over all keys and values.
        var i: Int = 0
        for (key, value) in object {
            // Append the key and value.
            output.append(indent + escape(string: key) + String(FileConstants.colon) + " ")
            parse(node: value, indentLevel: indentLevel + 1)
            // Add a comma if necessary.
            i += 1
            if i != object.count {
                output.append(FileConstants.comma)
            }
            output.append(lineEndings.rawValue)
        }
        // Close the object
        output.append(indentString(level: indentLevel - 1) + String(FileConstants.rightCurlyBracket))
    }
    
    /// Parses arrays.
    private func parse(array: [Node]) {
        // Open the array.
        output.append(FileConstants.leftSquareBracket)
        // Iterate over all the values.
        var i: Int = 0
        for value in array {
            // Append the value.
            parseValue(node: value)
            // Add a comma if necessary.
            i += 1
            if i != array.count {
                output.append(FileConstants.comma)
            }
        }
        // Close the array
        output.append(FileConstants.rightSquareBracket)
    }
    
    /// Parses arrays with pretty printing.
    private func parse(array: [Node], indentLevel: Int) {
        // Open the array.
        output.append(String(FileConstants.leftSquareBracket) + lineEndings.rawValue)
        // Pretty print.
        let indent = indentString(level: indentLevel)
        // Iterate over all the values.
        var i: Int = 0
        for value in array {
            // Append the value.
            output.append(indent)
            parse(node: value, indentLevel: indentLevel + 1)
            // Add a comma if necessary.
            i += 1
            if i != array.count {
                output.append(FileConstants.comma)
            }
            output.append(lineEndings.rawValue)
        }
        // Close the array.
        output.append(indentString(level: indentLevel - 1) + String(FileConstants.rightSquareBracket))
    }
    
    /// Parses numbers.
    private func parse(number: Double) {
        if number == Double(Int(number)) {
            output.append(String(Int(number)))
        } else {
            output.append(String(number))
        }
    }
    
    /// Parses strings.
    private func parse(string: String) {
        output.append("\"" + escape(string: string) + "\"")
    }
    
    /// Parses booleans.
    private func parse(boolean: Bool) {
        if boolean {
            output.append(JSONConstants.trueValue)
        } else {
            output.append(JSONConstants.falseValue)
        }
    }
    
    /// Parses null.
    private func parseNull() {
        output.append(JSONConstants.nullValue)
    }
    
    /// Escapes the given string.
    private func escape(string: String) -> String {
        return string.characters
            .map { JSONConstants.escapeMapping[$0] ?? String($0) }
            .joined(separator: "")
    }
    
    /// Creates the indent string for the given indentation level.
    private func indentString(level: Int) -> String {
        if level >= 0 {
            return Array(0...level)
                .map { _ in "    " }
                .joined(separator: "")
        } else {
            return ""
        }
    }
}
