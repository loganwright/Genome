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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
