//
//  INISerializer.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/12/16.
//
//

@_exported import Genome

/**
 Serializes a `Node` dictionary into an INI configuration file.
 */
public class INISerializer: Serializer {
    
    //---------------------------------
    // MARK: Properties
    //---------------------------------
    
    /// The delimeter to use when creating sub-sections.
    /// - default: Period (`.`)
    public var sectionDelimiter: UnicodeScalar = FileConstants.decimalScalar
    
    /// The delimiter of an array of values other than whitespace.
    /// - note: This is to allow support of reading ini files that have comma (`,`) separators instead of just spaces.
    public var arrayDelimiter: String = String(FileConstants.space)
    
    /// The delimiter between keys and values. Usually "`=`", but some ini files use: "`:`".
    /// - default: `=`
    public var keyValueDelimiter: UnicodeScalar = FileConstants.equalScalar
    
    /// Extra characters to escape from strings.
    /// - note: This is to support variations in the ini format that require escaping of certian characters. For example the octothorpe is sometimes treated as a comment identifier.
    public var escapeMapping: [Character : String] = [:]
    
    //---------------------------------
    // MARK: Parsing
    //---------------------------------
    
    override func parse(node: Node) throws -> String {
        // The only valid root node is an array.
        switch node {
        case let .object(object):
            try parseRoot(object: object)
            return output
        default:
            throw SerializationError.UnsupportedNodeType(reason: "The root node is expected to be an object.")
        }
    }
    
    private func parseRoot(object: [String: Node]) throws {
        
        // Check to see if the array is empty
        if object.count == 0 {
            throw SerializationError.EmptyInput
        }
        
        try parse(object: object, parentSection: "")
    }
    
    private func parseKey(key: String) {
        output.append(key + String(keyValueDelimiter))
    }
    
    /// Parses objects.
    private func parse(object: [String: Node], parentSection: String) throws {
        
        // Add the section identifier if necessary.
        if parentSection.characters.count != 0 {
            // Open the section.
            output.append(FileConstants.leftSquareBracket)
            // Append the section name.
            output.append(parentSection)
            // Close the section
            output.append(FileConstants.rightSquareBracket)
        }
        
        // Iterate over all keys and values.
        var i: Int = 0
        for (key, value) in object {
            //Determine what kind of value we have
            switch value {
            case .null:
                parseKey(key: key)
                parseNull()
                break
            case let .bool(boolean):
                parseKey(key: key)
                parse(boolean: boolean)
                break
            case let .number(number):
                parseKey(key: key)
                parse(number: number)
                break
            case let .string(string):
                parseKey(key: key)
                parse(string: string)
                break
            case let .object(object):
                try parse(object: object, parentSection: parentSection + String(sectionDelimiter) + key)
            case let .array(array):
                parseKey(key: key)
                try parse(array: array)
            }
            
            // Add a new line if necessary.
            i += 1
            if i != object.count {
                output.append(lineEndings.rawValue)
            }
        }
    }
    
    /// Parses arrays.
    private func parse(array: [Node]) throws {
        // Iterate over all the values.
        var i: Int = 0
        for value in array {
            // Append the value.
            try parseValue(node: value)
            // Add a comma if necessary.
            i += 1
            if i != array.count {
                output.append(arrayDelimiter)
            }
            break
        }
    }
    
    
    /// Determines the type of node and parses it accordingly.
    private func parseValue(node: Node) throws {
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
        default:
            throw SerializationError.UnsupportedNodeType(reason: "Child nodes of arrays must not be arrays or objects.")
        }
    }
    
    /// Parses null.
    private func parseNull() {
        output.append(INIConstants.nullValue)
    }
    
    /// Parses booleans.
    private func parse(boolean: Bool) {
        if boolean {
            output.append(INIConstants.trueValue)
        } else {
            output.append(INIConstants.falseValue)
        }
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
    
    /// Escapes the given string.
    private func escape(string: String) -> String {
        let baseEscape = string.characters
            .map { INIConstants.escapeMapping[$0] ?? String($0) }
            .joined(separator: "")
        if escapeMapping.count > 0 {
            return string.characters
                .map { escapeMapping[$0] ?? String($0) }
                .joined(separator: "")
        }
        return baseEscape
    }
}