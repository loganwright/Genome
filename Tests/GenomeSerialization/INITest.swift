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
                   ("sampleTest", sampleTest),
        ]
    }
    
    func sampleTest() throws {
        XCTFail("This still needs to be implemented")
        return
        
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