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
                   ("singleColumn", testSingleColumn),
                   ("testArrays", testArrays),
                   ("testObjects", testObjects),
                   ("testObjectsNoHeaders", testObjectsNoHeaders),
        ]
    }
    
    func testSingleColumn() throws {
        // Load the CSV data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "SingleColumn", type: "csv")
        
        // This is what we expect.
        let nodeRepresentation: Node = [["a"], ["b"], ["c"], ["d"], ["e"], ["f"], ["g"]]
        
        do {
            let deserializedData = try CSVDeserializer(isFirstRowHeaders: false).parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The CSV data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize CSV data: \(error)")
        }
        
        do {
            let serializedData = try CSVSerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try CSVDeserializer(isFirstRowHeaders: false).parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The CSV data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize CSV data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated CSV data: \(error)")
        }
    }
    
    func testArrays() throws {
        // Load the CSV data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "Arrays", type: "csv")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           ["a","b","c","d","e","f","g"],
                                           ["h","i","j","k","l","m","n"],
                                           ["o","p","q","r","s","t","u"],
                                           ["v","w","x","y","z"]
        ]
        
        do {
            let deserializedData = try CSVDeserializer(isFirstRowHeaders: false).parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The CSV data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize CSV data: \(error)")
        }
        
        do {
            let serializedData = try CSVSerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try CSVDeserializer(isFirstRowHeaders: false).parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The CSV data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize CSV data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated CSV data: \(error)")
        }
    }
    
    func testObjects() throws {
        // Load the CSV data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "Objects", type: "csv")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           ["string": "I am a string", "number": 2, "null": .null, "boolean": false],
                                           ["string": "I am a string", "number": 1.23, "null": .null, "boolean": true],
                                           ["string": "\"I am a string\"", "number": 123e3, "null": .null, "boolean": false],
                                           ["string": "I am a \"string\"", "number": 3, "null": .null, "boolean": true]
        ]
        
        do {
            let deserializedData = try CSVDeserializer(isFirstRowHeaders: true).parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The CSV data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize CSV data: \(error)")
        }
        
        do {
            let serializedData = try CSVSerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try CSVDeserializer(isFirstRowHeaders: true).parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The CSV data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize CSV data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated CSV data: \(error)")
        }
    }
    
    func testObjectsNoHeaders() throws {
        // Load the CSV data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "ObjectsNoHeader", type: "csv")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           ["string": "I am a string", "number": 2, "null": .null, "boolean": false],
                                           ["string": "I am a string", "number": 1.23, "null": .null, "boolean": true],
                                           ["string": "\"I am a string\"", "number": 123e3, "null": .null, "boolean": false],
                                           ["string": "I am a \"string\"", "number": 3, "null": .null, "boolean": true]
        ]
        
        do {
            let deserializedData = try CSVDeserializer(headers: ["string", "number", "null", "boolean"], containsHeader: false).parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The CSV data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize CSV data: \(error)")
        }
        
        do {
            let serializedData = try CSVSerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try CSVDeserializer().parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The CSV data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize CSV data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated CSV data: \(error)")
        }
    }
}

