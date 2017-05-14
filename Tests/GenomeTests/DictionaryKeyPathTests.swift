//
//  DictionaryKeyPathTests.swift
//  Genome
//
//  Created by Logan Wright on 7/2/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import Genome

class DictionaryKeyPathTests: XCTestCase {
    static let allTests = [
        ("testPaths", testPaths)
    ]
    
    func testPaths() {
        let TestDictionary: Node = [
            "one" : [
                "two" : "Found me!"
            ]
        ]

        var node = TestDictionary

        let value = node["one", "two"]?.string
        XCTAssertEqual(value, "Found me!")

        node["path", "to", "new", "value"] = "Hello!"
        let setVal = node["path", "to", "new", "value"]
        XCTAssertEqual(setVal, "Hello!")
    }
    
}
