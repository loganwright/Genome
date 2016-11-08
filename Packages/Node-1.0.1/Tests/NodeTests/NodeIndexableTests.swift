//
//  BasicTypes.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
@testable import Node

class NodeIndexableTests: XCTestCase {
    static let allTests = [
        ("testInt", testInt),
        ("testString", testString),
        ("testStringSequenceObject", testStringSequenceObject),
        ("testStringSequenceArray", testStringSequenceArray),
        ("testIntSequence", testIntSequence),
        ("testMixed", testMixed),
    ]

    func testInt() {
        let array: Node = ["one",
                           "two",
                           "three"]
        let path = [1]
        XCTAssert(array[path] == "two")
    }

    func testString() {
        let object: Node = ["a" : 1]
        XCTAssert(object["a"] == 1)
    }

    func testStringSequenceObject() {
        let ob: Node = ["key" : ["path" : "found me!"]]
        XCTAssert(ob["key", "path"] == "found me!")
    }

    func testStringSequenceArray() {
        let obArray: Node = [["a" : 0],
                             ["a" : 1],
                             ["a" : 2],
                             ["a" : 3]]
        let collection = obArray["a"]
        XCTAssert(collection == [0,1,2,3])
    }

    func testIntSequence() {
        let inner: Node = ["...",
                           "found me!"]
        let outer: Node = [inner]
        XCTAssert(outer[0, 1] == "found me!")
    }

    func testMixed() {
        let mixed: Node = ["one" : ["a", "b", "c"]]
        XCTAssert(mixed["one", 1] == "b")
    }
}
