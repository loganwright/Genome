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
        var TestDictionary: [NSObject : AnyObject] = [
            "one" : [
                "two" : "Found me!"
            ]
        ]
        
        let value: String! = TestDictionary.gnm_valueForKeyPath("one.two")
        XCTAssert(value == "Found me!")
        TestDictionary.gnm_setValue("Hello!", forKeyPath: "path.to.new.value")
        let setVal: String! = TestDictionary.gnm_valueForKeyPath("path.to.new.value")
        XCTAssert(setVal == "Hello!")
    }
    
}
