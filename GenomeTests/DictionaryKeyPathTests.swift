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
        
        var node = try! Node(TestDictionary)

        let value: String! = node.gnm_valueForKeyPath("one.two")?.stringValue
        XCTAssert(value == "Found me!")
        node.gnm_setValue("Hello!", forKeyPath: "path.to.new.value")
        let setVal: String! = node.gnm_valueForKeyPath("path.to.new.value")?.stringValue
        XCTAssert(setVal == "Hello!")
    }
    
}
