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
        if !prettyPrint {
            switch rootNode {
            case let .array(array):
                parseArray(array: array)
            case let .object(object):
                parseObject(object: object)
            default:
                throw SerializationError.UnsupportedNodeType(reason: "The root node is expected to be an array or object.")
            }
        } else {
            switch rootNode {
            case let .array(array):
                parseArray(array: array, indentLevel: 0)
            case let .object(object):
                parseObject(object: object, indentLevel: 0)
            default:
                throw SerializationError.UnsupportedNodeType(reason: "The root node is expected to be an array or object.")
            }
        }
        return (serializationDelegate as? SerializerConcatenate)?.output
    }
    
    private func parseValue(node: Node) {
        switch node {
        case .null:
            serializeNull()
            break
        case let .bool(boolean):
            serializeBoolean(boolean: boolean)
            break
        case let .number(number):
            serializeNumber(number: number)
            break
        case let .string(string):
            serializeString(string: string)
            break
        case let .object(object):
            parseObject(object: object)
        case let .array(array):
            parseArray(array: array)
        }
    }
    
    private func parseValue(node: Node, indentLevel: Int) {
        switch node {
        case .null:
            serializeNull()
            break
        case let .bool(boolean):
            serializeBoolean(boolean: boolean)
            break
        case let .number(number):
            serializeNumber(number: number)
            break
        case let .string(string):
            serializeString(string: string)
            break
        case let .object(object):
            parseObject(object: object, indentLevel: indentLevel)
        case let .array(array):
            parseArray(array: array, indentLevel: indentLevel)
        }
    }
    
    private func parseObject(object: [String: Node]) {
        serializationDelegate.serializerSerializedData(data: String(FileConstants.leftCurlyBracket))
        var i: Int = 0
        for (key, value) in object {
            serializationDelegate.serializerSerializedData(data: escapeString(string: key) + String(FileConstants.colon))
            parseValue(node: value)
            i += 1
            if i != object.count {
                serializationDelegate.serializerSerializedData(data: String(FileConstants.comma))
            }
        }
        serializationDelegate.serializerSerializedData(data: String(FileConstants.rightCurlyBracket))
    }
    
    private func parseObject(object: [String: Node], indentLevel: Int) {
        serializationDelegate.serializerSerializedData(data: String(FileConstants.leftCurlyBracket) + lineEndings.rawValue)
        let indent = indentString(level: indentLevel)
        var i: Int = 0
        for (key, value) in object {
            serializationDelegate.serializerSerializedData(data: indent + escapeString(string: key) + String(FileConstants.colon) + " ")
            parseValue(node: value, indentLevel: indentLevel + 1)
            i += 1
            if i != object.count {
                serializationDelegate.serializerSerializedData(data: String(FileConstants.comma))
            }
            serializationDelegate.serializerSerializedData(data: lineEndings.rawValue)
        }
        serializationDelegate.serializerSerializedData(data: indentString(level: indentLevel - 1) + String(FileConstants.rightCurlyBracket))
    }
    
    private func parseArray(array: [Node]) {
        serializationDelegate.serializerSerializedData(data: String(FileConstants.leftSquareBracket))
        var i: Int = 0
        for value in array {
            parseValue(node: value)
            i += 1
            if i != array.count {
                serializationDelegate.serializerSerializedData(data: String(FileConstants.comma))
            }
        }
        serializationDelegate.serializerSerializedData(data: String(FileConstants.rightSquareBracket))
    }
    
    private func parseArray(array: [Node], indentLevel: Int) {
        serializationDelegate.serializerSerializedData(data: String(FileConstants.leftSquareBracket) + lineEndings.rawValue)
        let indent = indentString(level: indentLevel)
        var i: Int = 0
        for value in array {
            serializationDelegate.serializerSerializedData(data: indent)
            parseValue(node: value, indentLevel: indentLevel + 1)
            i += 1
            if i != array.count {
                serializationDelegate.serializerSerializedData(data: String(FileConstants.comma))
            }
            serializationDelegate.serializerSerializedData(data: lineEndings.rawValue)
        }
        serializationDelegate.serializerSerializedData(data: indentString(level: indentLevel - 1) + String(FileConstants.rightSquareBracket))
    }
    
    private func serializeNumber(number: Double) {
        if number == Double(Int(number)) {
            serializationDelegate.serializerSerializedData(data: Int(number).description)
        } else {
            serializationDelegate.serializerSerializedData(data: number.description)
        }
    }
    
    private func serializeString(string: String) {
        serializationDelegate.serializerSerializedData(data: "\"" + escapeString(string: string) + "\"")
    }
    
    private func serializeBoolean(boolean: Bool) {
        if boolean {
            serializationDelegate.serializerSerializedData(data: JSONConstants.trueValue)
        } else {
            serializationDelegate.serializerSerializedData(data: JSONConstants.falseValue)
        }
    }
    
    private func serializeNull() {
        serializationDelegate.serializerSerializedData(data: JSONConstants.nullValue)
    }
    
    private func escapeString(string: String) -> String {
        return string.characters
            .map { JSONConstants.escapeMapping[$0] ?? String($0) }
            .joined(separator: "")
    }
    
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
