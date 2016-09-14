//
//  NodeEquatableTests.swift
//  Node
//
//  Created by Logan Wright on 7/20/16.
//
//

import XCTest
@testable import Node

class NodePolymorphicTests: XCTestCase {
    static let allTests = [
        ("testPolymorphicString", testPolymorphicString),
        ("testPolymorphicInt", testPolymorphicInt),
        ("testPolymorphicUInt", testPolymorphicUInt),
        ("testPolymorphicFloat", testPolymorphicFloat),
        ("testPolymorphicDouble", testPolymorphicDouble),
        ("testPolymorphicNull", testPolymorphicNull),
        ("testPolymorphicBool", testPolymorphicBool),
        ("testPolymorphicArray", testPolymorphicArray),
        ("testPolymorphicObject", testPolymorphicObject)
    ]

    func testPolymorphicString() {
        let bool: Node = true
        let int: Node = 1
        let double: Node = 3.14
        let string: Node = "hi"
        let ob: Node = .object(["key": "value"])
        let arr: Node = .array([1,2,3])
        let bytes: Node = .bytes([10, 20, 30, 40])

        XCTAssert(bool.string == "true")
        XCTAssert(int.string == "1")
        XCTAssert(double.string == "3.14")
        XCTAssert(string.string == "hi")
        XCTAssertNil(ob.string)
        XCTAssertNil(arr.string)
        XCTAssertNil(bytes.string)
    }

    func testPolymorphicInt() {
        let boolTrue: Node = true
        let boolFalse: Node = false
        let int: Node = 42
        let double: Node = 3.14
        let intString: Node = "123"

        let histring: Node = "hi"
        let ob: Node = .object(["key": "value"])
        let arr: Node = .array([1,2,3])
        let bytes: Node = .bytes([10, 20, 30, 40])

        XCTAssert(boolTrue.int == 1)
        XCTAssert(boolFalse.int == 0)
        XCTAssert(int.int == 42)
        XCTAssert(double.int == 3)
        XCTAssert(intString.int == 123)
        XCTAssertNil(histring.int)
        XCTAssertNil(ob.int)
        XCTAssertNil(arr.int)
        XCTAssertNil(bytes.int)
    }

    func testPolymorphicUInt() {
        let boolTrue: Node = true
        let boolFalse: Node = false
        let int: Node = 42
        let double: Node = 3.14
        let intString: Node = "123"

        let histring: Node = "hi"
        let ob: Node = .object(["key": "value"])
        let arr: Node = .array([1,2,3])
        let bytes: Node = .bytes([10, 20, 30, 40])

        XCTAssert(boolTrue.uint == 1)
        XCTAssert(boolFalse.uint == 0)
        XCTAssert(int.uint == 42)
        XCTAssert(double.uint == 3)
        XCTAssert(intString.uint == 123)
        XCTAssertNil(histring.uint)
        XCTAssertNil(ob.uint)
        XCTAssertNil(arr.uint)
        XCTAssertNil(bytes.uint)
    }

    func testPolymorphicFloat() {
        let boolTrue: Node = true
        let boolFalse: Node = false
        let int: Node = 42
        let double: Node = 3.14
        let intString: Node = "123"
        let doubleString: Node = "42.5997"

        let histring: Node = "hi"
        let ob: Node = .object(["key": "value"])
        let arr: Node = .array([1,2,3])
        let bytes: Node = .bytes([10, 20, 30, 40])

        XCTAssert(boolTrue.float == 1)
        XCTAssert(boolFalse.float == 0)
        XCTAssert(int.float == 42)
        XCTAssert(double.float == 3.14)
        XCTAssert(intString.float == 123)
        XCTAssert(doubleString.float == 42.5997)
        XCTAssertNil(histring.float)
        XCTAssertNil(ob.float)
        XCTAssertNil(arr.float)
        XCTAssertNil(bytes.float)
    }

    func testPolymorphicDouble() {
        let boolTrue: Node = true
        let boolFalse: Node = false
        let int: Node = 42
        let double: Node = 3.14
        let intString: Node = "123"
        let doubleString: Node = "42.5997"

        let histring: Node = "hi"
        let ob: Node = .object(["key": "value"])
        let arr: Node = .array([1,2,3])
        let bytes: Node = .bytes([10, 20, 30, 40])

        XCTAssert(boolTrue.double == 1)
        XCTAssert(boolFalse.double == 0)
        XCTAssert(int.double == 42)
        XCTAssert(double.double == 3.14)
        XCTAssert(intString.double == 123)
        XCTAssert(doubleString.double == 42.5997)
        XCTAssertNil(histring.double)
        XCTAssertNil(ob.double)
        XCTAssertNil(arr.double)
        XCTAssertNil(bytes.double)
    }

    func testPolymorphicNull() {
        let null: Node = .null
        let lowerNullString: Node = "null"
        let upperNullString: Node = "NULL"

        let bool: Node = true
        let int: Node = 42
        let double: Node = 3.14
        let string: Node = "hi"
        let ob: Node = .object(["key": "value"])
        let arr: Node = .array([1,2,3])
        let bytes: Node = .bytes([10, 20, 30, 40])

        XCTAssertTrue(null.isNull)
        XCTAssertTrue(lowerNullString.isNull)
        XCTAssertTrue(upperNullString.isNull)

        XCTAssertFalse(bool.isNull)
        XCTAssertFalse(int.isNull)
        XCTAssertFalse(double.isNull)
        XCTAssertFalse(string.isNull)
        XCTAssertFalse(ob.isNull)
        XCTAssertFalse(arr.isNull)
        XCTAssertFalse(bytes.isNull)
    }

    func testPolymorphicBool() {
        let null: Node = .null
        let bool: Node = true
        let int: Node = 42
        let boolInt: Node = 1
        let double: Node = 3.14
        let boolDouble: Node = 1.0
        let string: Node = "hi"
        let boolString: Node = "true"
        let ob: Node = .object(["key": "value"])
        let arr: Node = .array([1,2,3])
        let bytes: Node = .bytes([10, 20, 30, 40])

        XCTAssert(null.bool == false)
        XCTAssert(bool.bool == true)
        XCTAssertNil(int.bool)
        XCTAssert(boolInt.bool == true)
        XCTAssertNil(double.bool)
        XCTAssert(boolDouble.bool == true)
        XCTAssertNil(string.bool)
        XCTAssert(boolString.bool == true)
        XCTAssertNil(ob.bool)
        XCTAssertNil(arr.bool)
        XCTAssertNil(bytes.bool)
    }

    func testPolymorphicArray() {
        let null: Node = .null
        let bool: Node = true
        let int: Node = 42
        let double: Node = 3.14
        let string: Node = "hi"
        let arrayString: Node = "hi, there, array"
        let ob: Node = .object(["key": "value"])
        let arr: Node = .array([1,2,3])
        let bytes: Node = .bytes([10, 20, 30, 40])

        XCTAssertNil(null.array)
        XCTAssertNil(bool.array)
        XCTAssertNil(int.array)
        XCTAssertNil(double.array)

        let single = string.array?.flatMap { $0.string } ?? []
        XCTAssert(single == ["hi"])
        let fetched = arrayString.array?.flatMap { $0.string } ?? []
        XCTAssert(fetched == ["hi", "there", "array"])
        let array = arr.array?.flatMap { $0.int } ?? []
        XCTAssert(array == [1, 2, 3])

        XCTAssertNil(ob.array)
        XCTAssertNil(bytes.array)
    }

    func testPolymorphicObject() {
        let null: Node = .null
        let bool: Node = true
        let int: Node = 42
        let double: Node = 3.14
        let string: Node = "hi"
        let ob: Node = .object(["key": "value"])
        let arr: Node = .array([1,2,3])
        let bytes: Node = .bytes([10, 20, 30, 40])

        XCTAssertNotNil(ob.object)
        XCTAssert(ob.object?["key"]?.string == "value")
        
        XCTAssertNil(null.object)
        XCTAssertNil(bool.object)
        XCTAssertNil(int.object)
        XCTAssertNil(double.object)
        XCTAssertNil(string.object)
        XCTAssertNil(arr.object)
        XCTAssertNil(bytes.object)
        
    }

}
