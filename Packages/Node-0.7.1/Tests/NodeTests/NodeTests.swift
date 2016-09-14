//
//  NodeEquatableTests.swift
//  Node
//
//  Created by Logan Wright on 7/20/16.
//
//

import XCTest
@testable import Node

class NodeTests: XCTestCase {
    static let allTests = [
        ("testInits", testInits),
        ("testArrayInits", testArrayInits),
        ("testObjectInits", testObjectInits),
        ("testNonHomogenousArrayInits", testNonHomogenousArrayInits),
        ("testNonHomogenousObjectInits", testNonHomogenousObjectInits),
        ("testLiterals", testLiterals),
        ("testEquatable", testEquatable),
    ]

    func testInits() {
        // these are mostly here to ensure compilation errors don't occur
        XCTAssert(Node(true) == .bool(true))
        XCTAssert(Node("hi") == .string("hi"))
        XCTAssert(Node(1) == .number(1))
        XCTAssert(Node(3.14) == .number(3.14))

        let uint = UInt(42)
        XCTAssert(Node(uint) == .number(Node.Number(uint)))

        let number = Node.Number(2345)
        XCTAssert(Node(number) == .number(number))

        let array = [Node(1), Node(2), Node(3)]
        XCTAssert(Node(array) == .array([1,2,3]))

        let object = ["key": Node("value")]
        XCTAssert(Node(object) == .object(object))

        XCTAssert(Node(bytes: [1,2,3,4]) == .bytes([1,2,3,4]))
    }

    func testArrayInits() throws {
        let array: [Int] = [1,2,3,4,5]
        let node = try Node(node: array)
        XCTAssert(node == [1,2,3,4,5])

        let optionalArray: [String?] = ["a", "b", "c", nil, "d", nil]
        let optionalNode = try Node.init(node: optionalArray)
        XCTAssertEqual(optionalNode, ["a", "b", "c", .null, "d", .null])
    }

    func testObjectInits() throws {
        let dict: [String: String] = [
            "hello": "world",
            "goodbye": "moon"
        ]
        let node = try Node(node: dict)
        XCTAssert(node == ["hello": "world", "goodbye": "moon"])

        let optionalDict: [String: String?] = [
            "hello": "world",
            "goodbye": nil
        ]
        let optionalNode = try Node(node: optionalDict)
        XCTAssertEqual(optionalNode, ["hello": "world", "goodbye": .null])
    }

    func testNonHomogenousArrayInits() throws {
        let array: [NodeRepresentable] = [1, "hiya", Node.object(["a": "b"]), false]
        let node = try Node(node: array)
        XCTAssertEqual(node, [1, "hiya", Node.object(["a": "b"]), false])


        let optionalArray: [NodeRepresentable?] = [42, "bye", Node.array([1,2,3]), true, nil]
        let optionalNode = try Node(node: optionalArray)
        XCTAssertEqual(optionalNode, [42, "bye", Node.array([1,2,3]), true, .null])
    }

    func testNonHomogenousObjectInits() throws {
        let dict: [String: NodeRepresentable] = [
            "hello": "world",
            "goodbye": 1
        ]
        let node = try Node(node: dict)
        XCTAssertEqual(node, ["hello": "world", "goodbye": 1])

        let optionalDict: [String: NodeRepresentable?] = [
            "hello": "world",
            "goodbye": nil,
            "ok": 1
        ]
        let optionalNode = try Node(node: optionalDict)
        XCTAssertEqual(optionalNode, ["hello": "world", "goodbye": .null, "ok": 1])
    }

    func testLiterals() {
        XCTAssert(Node.null == nil)
        XCTAssert(Node.bool(false) == false)
        XCTAssert(Node.number(1) == 1)
        XCTAssert(Node.number(42.3) == 42.3)

        XCTAssert(Node.string("test") == "test")
        let unicode = Node(unicodeScalarLiteral: "test")
        XCTAssert(Node.string("test") == unicode)
        let grapheme = Node(extendedGraphemeClusterLiteral: "test")
        XCTAssert(Node.string("test") == grapheme)

        XCTAssert(Node.array([1,2,3]) == [1,2,3])
        XCTAssert(Node.object(["key": "value"]) == ["key": "value"])
    }

    func testEquatable() {
        let truthyPairs: [(Node, Node)] = [
            (nil, nil),
            (1, 1.0),
            (true, true),
            (false, false),
            ("hello", "hello"),
            ([1,2,3], [1,2,3]),
            (["key": "value"], ["key": "value"])
        ]

        truthyPairs.forEach { lhs, rhs in XCTAssert(lhs == rhs, "\(lhs) should equal \(rhs)") }

        let falsyPairs: [(Node, Node)] = [
            (nil, 42),
            (1, "hello"),
            (true, ["key": "value"]),
            ([1,2,3], false),
            ("hello", "goodbye"),
            ([1,2,3], [1,2,3,4]),
            (["key": "value"], ["array", "of", "strings"])
        ]

        falsyPairs.forEach { lhs, rhs in XCTAssert(lhs != rhs, "\(lhs) should equal \(rhs)") }
    }

}
