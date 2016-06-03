//
//  INITest.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/26/16.
//
//

import XCTest
import Foundation
@testable import GenomeSerialization

class INITest: XCTestCase {
    
    static var allTests: [(String, (INITest) -> () throws -> Void)] {
        return [
                   ("testStrings", testStrings),
                   ("testNumbers", testNumbers),
                   ("testNoGroups", testNoGroups),
                   ("testGroups", testGroups)
        ]
    }
    
    func testStrings() throws {
        
        // Load the CSV data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "Strings", type: "ini")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "SIMPLE": "HELLO_WORLD",
                                           "QUOTED": "Hello World",
                                           "COMMENT_IDENTIFIER": "TEST_;_ME",
                                           "COMMENT_IDENTIFIER_QUOTED": "Test ; Me",
                                           "ESCAPED_TAB": "TESTING_\t_TABS",
                                           "ESCAPED_TAB_QUOTED": "Testing \t Tabs"
        ]
        
        do {
            let deserializedData = try INIDeserializer().parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The INI data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize INI data: \(error)")
        }
        
        do {
            let serializedData = try INISerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try INIDeserializer().parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The INI data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize INI data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated INI data: \(error)")
        }
    }
    
    func testNumbers() throws {
        
        // Load the CSV data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "Numbers", type: "ini")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "INTEGER": 23,
                                           "DECIMAL": 1.23,
                                           "POSITIVEEXPONENT": 123e3
        ]
        
        do {
            let deserializedData = try INIDeserializer().parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The INI data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize INI data: \(error)")
        }
        
        do {
            let serializedData = try INISerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try INIDeserializer().parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The INI data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize INI data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated INI data: \(error)")
        }
    }
    
    func testNoGroups() throws {
        
        // Load the CSV data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "NoGroups", type: "ini")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "STRING": "HELLO_WORLD",
                                           "INTEGER": 2,
                                           "DOUBLE": 1.23,
                                           "BOOLEAN": true
        ]
        
        do {
            let deserializedData = try INIDeserializer().parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The INI data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize INI data: \(error)")
        }
        
        do {
            let serializedData = try INISerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try INIDeserializer().parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The INI data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize INI data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated INI data: \(error)")
        }
    }
    
    func testGroups() throws {
        
        // Load the CSV data
        let dataString = loadResource(fromBundle: NSBundle(for: self.dynamicType), resource: "Groups", type: "ini")
        
        // This is what we expect.
        let nodeRepresentation: Node = [
                                           "TOPLEVELA": "A",
                                           "TOPLEVELB": "B",
                                           "GROUPA" : [
                                                          "SUBAA": "A",
                                                          "SUBAB": "B",
                                                          "SUBAC": "C"
            ],
                                           "GROUPB": [
                                                         "SUBBA": "A",
                                                         "SUBBB": "B",
                                                         "SUBGROUPA": [
                                                                          "SUBBA": "A",
                                                                          "SUBBB": "B",
                                                                          "SUBBC": "C"
                                            ]
            ]
        ]
        
        do {
            let deserializedData = try INIDeserializer().parse(data: dataString)
            XCTAssert(nodeRepresentation == deserializedData, "The INI data was deserialized incorrectly.")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize INI data: \(error)")
        }
        
        do {
            let serializedData = try INISerializer().parse(node: nodeRepresentation)
            let reDeserializedData = try INIDeserializer().parse(data: serializedData)
            XCTAssert(nodeRepresentation == reDeserializedData, "The INI data was serialized incorrectly.")
        } catch let error as SerializationError {
            XCTFail("Failed to serialize INI data: \(error)")
        } catch let error as DeserializationError {
            XCTFail("Failed to deserialize generated INI data: \(error)")
        }
    }
}