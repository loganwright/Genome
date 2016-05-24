//
//  CSVTest.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/23/16.
//
//

import XCTest
import Foundation
@testable import GenomeSerialization

class CSVTest: XCTestCase {
    
    static var allTests: [(String, (CSVTest) -> () throws -> Void)] {
        return [
                   ("testSimpleArray", testSimpleArray),
                   ("testSimpleObject", testSimpleObject),
                   ("testConstants", testConstants),
                   ("testStrings", testStrings),
                   ("testNumbers", testNumbers),
                   ("testObjects", testObjects),
        ]
    }
    
    func testConstants() throws {
        // Load the JSON data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "Constants", type: "json")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "true": true,
                                           "false": false,
                                           "null": .null
        ]
        
        do {
            let deserializedData = try JSONDeserializer().parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The JSON data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize JSON data: \(error)")
        }
        
        do {
            let serializedData = try JSONSerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try JSONDeserializer().parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The JSON data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize JSON data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated JSON data: \(error)")
        }
    }
    
    func testNumbers() throws {
        // Load the JSON data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "Numbers", type: "json")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "integer": 123,
                                           "float": 123.456,
                                           "positiveExponent": 123456e3,
                                           "negativeExponent": 123.45599999999999 // Need to be more percise with deimals in the future.
        ]
        
        do {
            let deserializedData = try JSONDeserializer().parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The JSON data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize JSON data: \(error)")
        }
        
        do {
            let serializedData = try JSONSerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try JSONDeserializer().parse(data: serializedData)
            
            // The items are broken out into separate cases due to rounding errors.
            guard case let .object(dict) = reDeserializedData else {
                XCTFail("Failed to deserialize JSON data")
                return
            }
            
            guard case let .number(integer) = dict["integer"]! else {
                XCTFail("Failed to deserialize JSON data")
                return
            }
            XCTAssert(integer == 123)
            
            guard case let .number(floatNumber) = dict["float"]! else {
                XCTFail("Failed to deserialize JSON data")
                return
            }
            XCTAssert(floatNumber == 123.456)
            
            guard case let .number(positiveExponent) = dict["positiveExponent"]! else {
                XCTFail("Failed to deserialize JSON data")
                return
            }
            XCTAssert(positiveExponent == 123456e3)
            
            guard case let .number(negativeExponent) = dict["negativeExponent"]! else {
                XCTFail("Failed to deserialize JSON data")
                return
            }
            XCTAssert(negativeExponent == 123.456)
            
        } catch let error as SerializationError {
            XCTFail("Failed to serialize JSON data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated JSON data: \(error)")
        }
    }
    
    func testObjects() throws {
        // Load the JSON data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "Objects", type: "json")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "string": "I am a string",
                                           "integer": 123,
                                           "double": 123.456,
                                           "bool": true,
                                           "null": .null,
                                           "array": [
                                                        "I",
                                                        "am",
                                                        "an",
                                                        "array"
            ],
                                           "object": [
                                                         "string": "I am a string",
                                                         "integer": 123,
                                                         "double": 123.456,
                                                         "bool": true,
                                                         "null": .null,
                                                         "array": [
                                                                      "I",
                                                                      "am",
                                                                      "an",
                                                                      "array"
                                            ],
                                                         "object": [
                                                                       "a":"a",
                                                                       "b":"b",
                                                                       "c":"c"
                                            ]
            ]
        ]
        
        do {
            let deserializedData = try JSONDeserializer().parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The JSON data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize JSON data: \(error)")
        }
        
        do {
            let serializedData = try JSONSerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try JSONDeserializer().parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The JSON data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize JSON data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated JSON data: \(error)")
        }
    }
    
    func testSimpleArray() throws {
        // Load the JSON data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "SimpleArray", type: "json")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "a",
                                           "b",
                                           "c"
        ]
        
        do {
            let deserializedData = try JSONDeserializer().parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The JSON data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize JSON data: \(error)")
        }
        
        do {
            let serializedData = try JSONSerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try JSONDeserializer().parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The JSON data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize JSON data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated JSON data: \(error)")
        }
    }
    
    func testSimpleObject() throws {
        // Load the JSON data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "SimpleObject", type: "json")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "a": "b",
                                           "c": "d",
                                           "e": "f"
        ]
        
        do {
            let deserializedData = try JSONDeserializer().parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The JSON data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize JSON data: \(error)")
        }
        
        do {
            let serializedData = try JSONSerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try JSONDeserializer().parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The JSON data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize JSON data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated JSON data: \(error)")
        }
    }
    
    func testStrings() throws {
        // Load the JSON data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "Strings", type: "json")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "simple":"hello world",
                                           "escapedNewline":"There is a newline\nin the middle of this sentence.",
                                           "escapedTab":"There is a tab\t in the middle of this sentence.",
                                           "unicode":"\u{0264}"
        ]
        
        do {
            let deserializedData = try JSONDeserializer().parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The JSON data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize JSON data: \(error)")
        }
        
        do {
            let serializedData = try JSONSerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try JSONDeserializer().parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The JSON data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize JSON data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated JSON data: \(error)")
        }
    }
}

