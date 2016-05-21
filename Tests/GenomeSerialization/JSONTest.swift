//
//  JSONTest.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/12/16.
//
//

import XCTest
import Foundation
@testable import GenomeSerialization

class JSONTest: XCTestCase {
    
    static var allTests: [(String, (JSONTest) -> () throws -> Void)] {
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
        let dataPath = NSBundle.main().pathForResource("Constants", ofType: "json")!
        let dataString = try String(contentsOfFile: dataPath, encoding: NSUTF8StringEncoding)
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "true": true,
                                           "false": false,
                                           "null": .null
        ]
        
        let deserializedData = try JSONDeserializer().parse(data: dataString)
        XCTAssert(nodeRepresentation == deserializedData, "The JSON data was deserialized incorrectly.")
        
        let serializedData = try JSONSerializer().parse(node: nodeRepresentation)
        let reDeserializedData = try JSONDeserializer().parse(data: serializedData)
        XCTAssert(nodeRepresentation == reDeserializedData, "The JSON data was serialized incorrectly.")
    }
    
    func testNumbers() throws {
        // Load the JSON data
        let dataPath = NSBundle.main().pathForResource("Numbers", ofType: "json")!
        let dataString = try String(contentsOfFile: dataPath, encoding: NSUTF8StringEncoding)
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "integer": 123,
                                           "float": 123.456,
                                           "double": 3875234856348.3957345283045,
                                           "positiveExponent": 123456e3,
                                           "negativeExponent": 123456e-3
        ]
        
        let deserializedData = try JSONDeserializer().parse(data: dataString)
        XCTAssert(nodeRepresentation == deserializedData, "The JSON data was deserialized incorrectly.")
        
        let serializedData = try JSONSerializer().parse(node: nodeRepresentation)
        let reDeserializedData = try JSONDeserializer().parse(data: serializedData)
        XCTAssert(nodeRepresentation == reDeserializedData, "The JSON data was serialized incorrectly.")
    }
    
    func testObjects() throws {
        // Load the JSON data
        let dataPath = NSBundle.main().pathForResource("Objects", ofType: "json")!
        let dataString = try String(contentsOfFile: dataPath, encoding: NSUTF8StringEncoding)
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "string": "I am a string",
                                           "integer": 123,
                                           "double": 123.456,
                                           "exponent": 123456e-3,
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
                                                         "exponent": 123456e-3,
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
        
        let deserializedData = try JSONDeserializer().parse(data: dataString)
        XCTAssert(nodeRepresentation == deserializedData, "The JSON data was deserialized incorrectly.")
        
        let serializedData = try JSONSerializer().parse(node: nodeRepresentation)
        let reDeserializedData = try JSONDeserializer().parse(data: serializedData)
        XCTAssert(nodeRepresentation == reDeserializedData, "The JSON data was serialized incorrectly.")
    }
    
    func testSimpleArray() throws {
        // Load the JSON data
        let dataPath = NSBundle.main().pathForResource("SimpleArray", ofType: "json")!
        let dataString = try String(contentsOfFile: dataPath, encoding: NSUTF8StringEncoding)
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "a",
                                           "b",
                                           "c"
        ]
        
        let deserializedData = try JSONDeserializer().parse(data: dataString)
        XCTAssert(nodeRepresentation == deserializedData, "The JSON data was deserialized incorrectly.")
        
        let serializedData = try JSONSerializer().parse(node: nodeRepresentation)
        let reDeserializedData = try JSONDeserializer().parse(data: serializedData)
        XCTAssert(nodeRepresentation == reDeserializedData, "The JSON data was serialized incorrectly.")
    }
    
    func testSimpleObject() throws {
        // Load the JSON data
        let dataPath = NSBundle.main().pathForResource("SimpleObject", ofType: "json")!
        let dataString = try String(contentsOfFile: dataPath, encoding: NSUTF8StringEncoding)
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "a": "b",
                                           "c": "d",
                                           "e": "f"
        ]
        
        let deserializedData = try JSONDeserializer().parse(data: dataString)
        XCTAssert(nodeRepresentation == deserializedData, "The JSON data was deserialized incorrectly.")
        
        let serializedData = try JSONSerializer().parse(node: nodeRepresentation)
        let reDeserializedData = try JSONDeserializer().parse(data: serializedData)
        XCTAssert(nodeRepresentation == reDeserializedData, "The JSON data was serialized incorrectly.")
    }
    
    func testStrings() throws {
        // Load the JSON data
        let dataPath = NSBundle.main().pathForResource("SimpleObject", ofType: "json")!
        let dataString = try String(contentsOfFile: dataPath, encoding: NSUTF8StringEncoding)
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "simple":"hello world",
                                           "escapedNewline":"There is a newline\nin the middle of this sentence.",
                                           "escapedTab":"There is a tab\t in the middle of this sentence.",
                                           "unicode":"\u{00f8C}"
        ]
        
        let deserializedData = try JSONDeserializer().parse(data: dataString)
        XCTAssert(nodeRepresentation == deserializedData, "The JSON data was deserialized incorrectly.")
        
        let serializedData = try JSONSerializer().parse(node: nodeRepresentation)
        let reDeserializedData = try JSONDeserializer().parse(data: serializedData)
        XCTAssert(nodeRepresentation == reDeserializedData, "The JSON data was serialized incorrectly.")
    }
}
