//
//  GenomeTests.swift
//  GenomeTests
//
//  Created by Logan Wright on 9/25/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
@testable import Genome

class GenomeTests: XCTestCase {
    
    let json: JSON = [
        "name" : NSNull()
    ]
    
    struct Model : BasicMappable {
        var name: String? = ""
        mutating func sequence(map: Map) throws {
            try name <~ map["name"]
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let model = try! Model.mappedInstance(json)
        XCTAssert(model.name == nil)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
