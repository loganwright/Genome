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
        let TestDictionary: AnyObject = [
            "one" : [
                "two" : "Found me!"
            ]
        ]
        
        var node = Node(TestDictionary)

        let value: String! = node["one", "two"]?.stringValue
        XCTAssert(value == "Found me!")
        node["path", "to", "new", "value"] = "Hello!"
        let setVal: String! = node["path", "to", "new", "value"]?.stringValue//node.get(forKeyPath: "path.to.new.value")?.stringValue
        XCTAssert(setVal == "Hello!")

// TODO: Make warning for these!
//        let value: String! = node.get(forKeyPath: "one.two")?.stringValue
//        XCTAssert(value == "Found me!")
//        node.set(val: "Hello!", forKeyPath: "path.to.new.value")
//        let setVal: String! = node.get(forKeyPath: "path.to.new.value")?.stringValue
//        XCTAssert(setVal == "Hello!")
    }
    
}
