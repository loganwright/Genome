//
//  DictionaryKeyPathTests.swift
//  Genome
//
//  Created by Logan Wright on 7/2/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import PathIndexable

class DictionaryKeyPathTests: XCTestCase {
    static var allTests = [
        ("testPaths", testPaths)
    ]
    
    func testPaths() {
        let inner = Node(["two" : .string("Found me!")])
        var test = Node([
            "one" : inner
        ])

        guard let node = test["one", "two"] else {
            XCTFail()
            return
        }

        guard case let .string(str) = node else {
            XCTFail()
            return
        }
        XCTAssert(str == "Found me!")

        test["path", "to", "new", "value"] = .string("Hello!")
        guard let setVal = test["path", "to", "new", "value"] else {
            XCTFail()
            return
        }
        guard case let .string(setStr) = setVal else {
            XCTFail()
            return
        }

        XCTAssert(setStr == "Hello!")
    }
    
}
