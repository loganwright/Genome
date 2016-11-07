//
//  BasicTypes.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
@testable import PathIndexable

enum Node {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array([Node])
    case object([String:Node])
}

extension Node: PathIndexable {
    var pathIndexableArray: [Node]? {
        guard case let .array(arr) = self else {
            return nil
        }
        return arr
    }

    var pathIndexableObject: [String: Node]? {
        guard case let .object(ob) = self else {
            return nil
        }
        return ob
    }

    init(_ array: [Node]) {
        self = .array(array)
    }

    init(_ object: [String: Node]) {
        self = .object(object)
    }
}

class PathIndexableTests: XCTestCase {
    static var allTests = [
        ("testInt", testInt),
        ("testString", testString),
        ("testStringSequenceObject", testStringSequenceObject),
        ("testStringSequenceArray", testStringSequenceArray),
        ("testIntSequence", testIntSequence),
        ("testMixed", testMixed),
        ("testAccessNil", testAccessNil),
    ]

    func testInt() {
        let array: Node = .array(["one",
                                  "two",
                                  "three"].map(Node.string))
        guard let node = array[1] else {
            XCTFail()
            return
        }
        guard case let .string(val) = node else {
            XCTFail()
            return
        }

        XCTAssert(val == "two")
    }

    func testString() {
        let object = Node(["a" : .number(1)])
        guard let node = object["a"] else {
            XCTFail()
            return
        }
        guard case let .number(val) = node else {
            XCTFail()
            return
        }

        XCTAssert(val == 1)
    }

    func testStringSequenceObject() {
        let sub = Node(["path" : .string("found me!")])
        let ob = Node(["key" : sub])
        guard let node = ob["key", "path"] else {
            XCTFail()
            return
        }
        guard case let .string(val) = node else {
            XCTFail()
            return
        }
        
        XCTAssert(val == "found me!")
    }

    func testStringSequenceArray() {
        let zero = Node(["a" : .number(0)])
        let one = Node(["a" : .number(1)])
        let two = Node(["a" : .number(2)])
        let three = Node(["a" : .number(3)])
        let obArray = Node([zero, one, two, three])

        guard let collection = obArray["a"] else {
            XCTFail()
            return
        }
        guard case let .array(value) = collection else {
            XCTFail()
            return
        }

        let mapped: [Double] = value.flatMap { node in
            guard case let .number(val) = node else {
                return nil
            }
            return val
        }
        XCTAssert(mapped == [0,1,2,3])
    }

    func testIntSequence() {
        let inner = Node([.string("..."),
                          .string("found me!")])
        let outer = Node([inner])

        guard let node = outer[0, 1] else {
            XCTFail()
            return
        }
        guard case let .string(value) = node else {
            XCTFail()
            return
        }

        XCTAssert(value == "found me!")
    }

    func testMixed() {
        let array = Node([.string("a"), .string("b"), .string("c")])
        let mixed = Node(["one" : array])

        guard let node = mixed["one", 1] else {
            XCTFail()
            return
        }
        guard case let .string(value) = node else {
            XCTFail()
            return
        }

        XCTAssert(value == "b")
    }

    func testOutOfBounds() {
        var array = Node([.number(1.0), .number(2.0), .number(3.0)])
        XCTAssertNil(array[3])
        array[3] = .number(4.0)
        XCTAssertNil(array[3])
    }

    func testSetArray() {
        var array = Node([.number(1.0), .number(2.0), .number(3.0)])
        XCTAssertEqual(array[1], .number(2.0))
        array[1] = .number(4.0)
        XCTAssertEqual(array[1], .number(4.0))
        array[1] = nil
        XCTAssertEqual(array[1], .number(3.0))
    }

    func testMakeEmpty() {
        let int: Int = 5
        let node: Node = int.makeEmptyStructure()
        XCTAssertEqual(node, .array([]))
    }

    func testAccessNil() {
        let array = Node([.object(["test": .number(42)]), .number(5)])
        XCTAssertNil(array["foo"])
        
        if let keyValResult = array["test"], case let .array(array) = keyValResult {
            XCTAssertEqual(array.count, 1)
            XCTAssertEqual(array.first, .number(42))
        } else {
            XCTFail("Expected array result from array key val")
        }

        let number = Node.number(5)
        XCTAssertNil(number["test"])
    }

    func testSetObject() {
        var object = Node([
            "one": .number(1.0),
            "two": .number(2.0),
            "three": .number(3.0)
        ])
        XCTAssertEqual(object["two"], .number(2.0))
        object["two"] = .number(4.0)
        XCTAssertEqual(object["two"], .number(4.0))
        object["two"] = nil
        XCTAssertEqual(object["two"], nil)

        var array = Node([object, object])
        array["two"] = .number(5.0)
    }

    func testPath() {
        var object = Node([
            "one": Node([
                "two": .number(42)
            ])
        ])
        XCTAssertEqual(object[path: "one.two"], .number(42))

        object[path: "one.two"] = .number(5)
        XCTAssertEqual(object[path: "one.two"], .number(5))

        let comps = "one.two.5.&".keyPathComponents()
        XCTAssertEqual(comps, ["one", "two", "5", "&"])
    }

    func testStringPathIndex() {
        let path = ["hello", "3"]
        let node = Node(
            [
                "hello": .array([
                    .string("a"),
                    .string("b"),
                    .string("c"),
                    .string("d")
                ])
            ]
        )


        if let n = node[path], case let .string(result) = n {
            print(result)
            XCTAssert(result == "d")
        } else {
            XCTFail("Expected result")
        }
    }
}

extension Node: Equatable {

}

func ==(lhs: Node, rhs: Node) -> Bool {
    switch (lhs, rhs) {
    case (.number(let l), .number(let r)):
        return l == r
    case (.array(let l), .array(let r)):
        return l == r
    default:
        return false
    }
}
