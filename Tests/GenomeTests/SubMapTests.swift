//
//  SubMapTests.swift
//  Genome
//
//  Created by Tim Vermeulen on 16/05/2017.
//
//

import XCTest

@testable import Genome

class SubMapTest: XCTestCase {
    static let allTests = [
        ("testFromNode", testFromNode)
    ]
    
    let testNode: Node = [
        "bar": 123,
        "foo": [
            "baz": 456,
            "baq": 789
        ]
    ]
    
    struct TestFromNode: MappableObject {
        let bar: Int
        let baz: Int
        let baq: Int
        
        init(map: Map) throws {
            bar = try map.extract("bar")
            
            let foo = map["foo"]
            
            baz = try foo.extract("baz")
            baq = try foo.extract("baq")
        }
    }
    
    struct TestToNode: BasicMappable {
        var bar: Int?
        var baz: Int?
        var baq: Int?
        
        mutating func sequence(_ map: Map) throws {
            try bar <~> map["bar"]
            
            let foo = map["foo"]
            
            try baz <~> foo["baz"]
            try baq <~> foo["baq"]
        }
    }
    
    func testFromNode() throws {
        let test = try TestFromNode(node: testNode)
        
        XCTAssertEqual(test.bar, 123)
        XCTAssertEqual(test.baz, 456)
        XCTAssertEqual(test.baq, 789)
    }
    
    func testToNode() throws {
        let test = try TestToNode(node: testNode)
        let dict = try test.makeNode()

        XCTAssertEqual(dict, testNode)
    }
}
