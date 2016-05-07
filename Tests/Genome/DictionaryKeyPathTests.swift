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
    
    func testExample() {
        let TestDictionary: Node = [
            "one" : [
                "two" : "Found me!"
            ]
        ]

        var node = TestDictionary

        let value: String! = node["one", "two"]?.string
        XCTAssert(value == "Found me!")

        node["path", "to", "new", "value"] = "Hello!"
        let setVal = node["path", "to", "new", "value"]
        XCTAssert(setVal == "Hello!")
    }
    
}
