//
//  ConvertibleTests.swift
//  Node
//
//  Created by Logan Wright on 7/20/16.
//
//

import XCTest
import Node

class BasicConvertibleTests: XCTestCase {
    static let allTests = [
        ("testBoolInit", testBoolInit),
        ("testBoolRepresent", testBoolRepresent),
        ("testIntegerInit", testIntegerInit),
        ("testIntegerRepresent", testIntegerRepresent),
        ("testDoubleInit", testDoubleInit),
        ("testDoubleRepresent", testDoubleRepresent),

        ("testFloatInit", testFloatInit),
        ("testFloatRepresent", testFloatRepresent),
        ("testUnsignedIntegerInit", testUnsignedIntegerInit),
        ("testUnsignedIntegerRepresent", testUnsignedIntegerRepresent),
        ("testStringInit", testStringInit),
        ("testStringRepresent", testStringRepresent),
        ("testNodeConvertible", testNodeConvertible),
    ]

    func testBoolInit() throws {
        let truths: [Node] = [
            "true", "t", "yes", "y", 1, 1.0, "1"
        ]
        try truths.forEach { truth in try XCTAssert(Bool(node: truth)) }

        let falsehoods: [Node] = [
            "false", "f", "no", "n", 0, 0.0, "0"
        ]
        try falsehoods.forEach { falsehood in try XCTAssert(!Bool(node: falsehood)) }

        let fails: [Node] = [
            [1,2,3], ["key": "value"], .null
        ]
        try assert(Bool.self, fails: fails)
    }

    func testBoolRepresent() {
        let truthy = true.makeNode()
        let falsy = false.makeNode()
        XCTAssert(truthy == .bool(true))
        XCTAssert(falsy == .bool(false))
    }

    func testIntegerInit() throws {
        let string = Node("400")
        let int = Node(-42)
        let double = Node(55.6)
        let bool = Node(true)

        try XCTAssert(Int(node: string) == 400)
        try XCTAssert(Int(node: int) == -42)
        try XCTAssert(Int(node: double) == 55)
        try XCTAssert(Int(node: bool) == 1)

        let fails: [Node] = [
            [1,2,3], ["key": "value"], .null
        ]
        try assert(Int.self, fails: fails)
    }

    func testIntegerRepresent() throws {
        let node = try 124.makeNode()
        XCTAssert(node == .number(124))
    }

    func testDoubleInit() throws {
        let string = Node("433.1029")
        let int = Node(-42)
        let double = Node(55.6)
        let bool = Node(true)

        try XCTAssert(Double(node: string) == 433.1029)
        try XCTAssert(Double(node: int) == -42.0)
        try XCTAssert(Double(node: double) == 55.6)
        try XCTAssert(Double(node: bool) == 1.0)

        let fails: [Node] = [
            [1,2,3], ["key": "value"], .null
        ]
        try assert(Double.self, fails: fails)
    }

    func testDoubleRepresent() {
        let node = 124.534.makeNode()
        XCTAssert(node == .number(124.534))
    }

    func testFloatInit() throws {
        let string = Node("433.1029")
        let int = Node(-42)
        let double = Node(55.6)
        let bool = Node(true)

        try XCTAssert(Float(node: string) == 433.1029)
        try XCTAssert(Float(node: int) == -42.0)
        try XCTAssert(Float(node: double) == 55.6)
        try XCTAssert(Float(node: bool) == 1.0)

        let fails: [Node] = [
            [1,2,3], ["key": "value"], .null
        ]
        try assert(Float.self, fails: fails)
    }

    func testFloatRepresent() {
        let float = Float(123.0)
        let node = float.makeNode()
        XCTAssert(node == .number(123.0))
    }

    func testUnsignedIntegerInit() throws {
        let string = Node("400")
        let int = Node(42)
        let double = Node(55.6)
        let bool = Node(true)

        try XCTAssert(UInt(node: string) == 400)
        try XCTAssert(UInt(node: int) == 42)
        try XCTAssert(UInt(node: double) == 55)
        try XCTAssert(UInt(node: bool) == 1)

        let fails: [Node] = [
            [1,2,3], ["key": "value"], .null
        ]
        try assert(UInt.self, fails: fails)
    }

    func testUnsignedIntegerRepresent() throws {
        let uint = UInt(124)
        let node = try uint.makeNode()
        XCTAssert(node == .number(124))
    }

    func testStringInit() throws {
        let string = Node("hello :)")
        let int = Node(42)
        let double = Node(55.6)
        let bool = Node(true)

        try XCTAssert(String(node: string) == "hello :)")
        try XCTAssert(String(node: int) == "42")
        try XCTAssert(String(node: double) == "55.6")
        try XCTAssert(String(node: bool) == "true")

        let fails: [Node] = [
            [1,2,3], ["key": "value"], .null
        ]
        try assert(String.self, fails: fails)
    }

    func testStringRepresent() {
        let node = "hello :)".makeNode()
        XCTAssert(node == .string("hello :)"))
    }

    func testNodeConvertible() throws {
        let node = Node("hello node")
        let initted = try Node(node: node)
        let made = node.makeNode()
        XCTAssert(initted == made)
    }

    private func assert<N: NodeInitializable>(_ n: N.Type, fails cases: [Node]) throws {
        try cases.forEach { fail in
            do {
                _ = try N(node: fail)
            } catch NodeError.unableToConvert(node: _, expected: _) {}
        }
    }
}
