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
        
        var dna = Dna.from(TestDictionary)

        let value: String! = dna.gnm_valueForKeyPath("one.two")?.stringValue
        XCTAssert(value == "Found me!")
        dna.gnm_setValue("Hello!", forKeyPath: "path.to.new.value")
        let setVal: String! = dna.gnm_valueForKeyPath("path.to.new.value")?.stringValue
        XCTAssert(setVal == "Hello!")
    }
    
}
