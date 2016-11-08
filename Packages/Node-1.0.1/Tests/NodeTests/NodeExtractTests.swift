//
//  BasicTypes.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import Foundation
@testable import Node

struct NoNull: NodeInitializable, Hashable {
    let node: Node

    var hashValue: Int {
        return "\(node)".hashValue
    }

    init(node: Node, in context: Context) throws {
        guard node != .null else {
            throw NodeError.unableToConvert(node: node, expected: "something not null")
        }
        
        self.node = node
    }
}

func == (l: NoNull, r: NoNull) -> Bool {
    return l.node == r.node
}

class NodeExtractTests: XCTestCase {
    static let allTests = [
        ("testExtractTransform", testExtractTransform),
        ("testExtractTransformThrows", testExtractTransformThrows),
        ("testExtractTransformOptionalValue", testExtractTransformOptionalValue),
        ("testExtractTransformOptionalNil", testExtractTransformOptionalNil),
        ("testExtractSingle", testExtractSingle),
        ("testExtractSingleOptional", testExtractSingleOptional),
        ("testExtractSingleThrows", testExtractSingleThrows),
        ("testExtractArray", testExtractArray),
        ("testExtractArrayOptional", testExtractArrayOptional),
        ("testExtractArrayThrows", testExtractArrayThrows),
        ("testExtractArrayOfArrays", testExtractArrayOfArrays),
        ("testExtractArrayOfArraysOptional", testExtractArrayOfArraysOptional),
        ("testExtractArrayOfArraysThrows", testExtractArrayOfArraysThrows),
        ("testExtractObject", testExtractObject),
        ("testExtractObjectOptional", testExtractObjectOptional),
        ("testExtractObjectThrows", testExtractObjectThrows),
        ("testExtractObjectOfArrays", testExtractObjectOfArrays),
        ("testExtractObjectOfArraysOptional", testExtractObjectOfArraysOptional),
        ("testExtractObjectOfArraysThrows", testExtractObjectOfArraysThrows),
        ("testExtractSet", testExtractSet),
        ("testExtractSetOptional", testExtractSetOptional),
        ("testExtractSetThrows", testExtractSetThrows),
    ]

    func testExtractTransform() throws {
        let node = try Node(node: ["date": 250])
        let extracted = try node.extract("date", transform: Date.fromTimestamp)
        XCTAssert(extracted.timeIntervalSince1970 == 250)
    }

    func testExtractTransformThrows() throws {
        let node = EmptyNode
        do {
            _ = try node.extract("date", transform: Date.fromTimestamp)
            XCTFail("should throw error")
        } catch NodeError.unableToConvert {}
    }

    func testExtractTransformOptionalValue() throws {
        let node = try Node(node: ["date": 250])
        let extracted = try node.extract("date", transform: Date.optionalFromTimestamp)
        XCTAssert(extracted?.timeIntervalSince1970 == 250)
    }

    func testExtractTransformOptionalNil() throws {
        let node = EmptyNode
        let extracted = try node.extract("date", transform: Date.optionalFromTimestamp)
        XCTAssertNil(extracted)
    }

    func testExtractSingle() throws {
        let node = try Node(node: ["nest": [ "ed": ["hello": "world", "pi": 3.14159]]])
        let extracted = try node.extract("nest", "ed", "hello") as NoNull
        XCTAssert(extracted.node.string == "world")
    }

    func testExtractSingleOptional() throws {
        let node = try Node(node: ["nest": [ "ed": ["hello": "world", "pi": 3.14159]]])
        let extracted: NoNull? = try node.extract("nest", "ed", "hello")
        XCTAssert(extracted?.node.string == "world")
    }

    func testExtractSingleThrows() throws {
        let node = EmptyNode
        do {
            _ = try node.extract("nest", "ed", "hello") as NoNull
            XCTFail("should throw node error unable to convert")
        } catch NodeError.unableToConvert {}
    }

    func testExtractArray() throws {
        let node = try Node(node: ["nest": [ "ed": ["array": [1, 2, 3, 4]]]])
        let extracted = try node.extract("nest", "ed", "array") as [NoNull]
        let numbers = extracted.flatMap { $0.node.int }
        XCTAssert(numbers == [1,2,3,4])
    }

    func testExtractArrayOptional() throws {
        let node = try Node(node: ["nest": [ "ed": ["array": [1, 2, 3, 4]]]])
        let extracted: [NoNull]? = try node.extract("nest", "ed", "array")
        let numbers = extracted?.flatMap { $0.node.int } ?? []
        XCTAssert(numbers == [1,2,3,4])
    }

    func testExtractArrayThrows() throws {
        let node = EmptyNode
        do {
            _ = try node.extract("nest", "ed", "array") as [NoNull]
            XCTFail("should throw node error unable to convert")
        } catch NodeError.unableToConvert {}
    }

    func testExtractArrayOfArrays() throws {
        let node = try Node(node: ["nest": [ "ed": ["array": [[1], [2], [3], [4]]]]])
        let extracted = try node.extract("nest", "ed", "array") as [[NoNull]]
        let numbers = extracted.map { innerArray in
            innerArray.flatMap { $0.node.int }
        }

        guard numbers.count == 4 else {
            XCTFail("failed array of arrays")
            return
        }
        XCTAssert(numbers[0] == [1])
        XCTAssert(numbers[1] == [2])
        XCTAssert(numbers[2] == [3])
        XCTAssert(numbers[3] == [4])
    }

    func testExtractArrayOfArraysOptional() throws {
        let node = try Node(node: ["nest": [ "ed": ["array": [[1], [2], [3], [4]]]]])
        let extracted: [[NoNull]]? = try node.extract("nest", "ed", "array")
        let numbers = extracted?.map { innerArray in
            innerArray.flatMap { $0.node.int }
        } ?? []

        guard numbers.count == 4 else {
            XCTFail("failed array of arrays optional")
            return
        }
        XCTAssert(numbers[0] == [1])
        XCTAssert(numbers[1] == [2])
        XCTAssert(numbers[2] == [3])
        XCTAssert(numbers[3] == [4])
    }

    func testExtractArrayOfArraysThrows() throws {
        do {
            let node = EmptyNode
            _ = try node.extract("nest", "ed", "array") as [[NoNull]]
            XCTFail("should throw node error unable to convert")
        } catch NodeError.unableToConvert {}
    }

    func testExtractObject() throws {
        let node = try Node(node: ["nest": [ "ed": ["object": ["hello": "world"]]]])
        let extracted = try node.extract("nest", "ed", "object") as [String: NoNull]
        XCTAssert(extracted["hello"]?.node.string == "world")
    }

    func testExtractObjectOptional() throws {
        let node = try Node(node: ["nest": [ "ed": ["object": ["hello": "world"]]]])
        let extracted: [String: NoNull]? = try node.extract("nest", "ed", "object")
        XCTAssert(extracted?["hello"]?.node.string == "world")
    }

    func testExtractObjectThrows() throws {
        let node = EmptyNode
        do {
            _ = try node.extract("dont", "exist", 0) as [String: NoNull]
            XCTFail("should throw node error unable to convert")
        } catch NodeError.unableToConvert {}
    }

    func testExtractObjectOfArrays() throws {
        let node = try Node(node: ["nest": [ "ed": ["object": ["hello": [1,2,3,4]]]]])
        let extracted = try node.extract("nest", "ed", "object") as [String: [NoNull]]
        let ints = extracted["hello"]?.flatMap({ $0.node.int }) ?? []
        XCTAssert(ints == [1,2,3,4])
    }

    func testExtractObjectOfArraysOptional() throws {
        let node = try Node(node: ["nest": [ "ed": ["object": ["hello": [1,2,3,4]]]]])
        let extracted: [String: [NoNull]]? = try node.extract("nest", "ed", "object")
        let ints = extracted?["hello"]?.flatMap({ $0.node.int }) ?? []
        XCTAssert(ints == [1,2,3,4])
    }

    func testExtractObjectOfArraysThrows() throws {
        let node = EmptyNode
        do {
            _ = try node.extract("dont", "exist", 0) as [String: [NoNull]]
            XCTFail("should throw node error unable to convert")
        } catch NodeError.unableToConvert {}
    }

    func testExtractSet() throws {
        let node = try Node(node: ["nest": [ "ed": ["array": [1, 2, 3, 4]]]])
        let extracted = try node.extract("nest", "ed", "array") as Set<NoNull>
        let ints = [1,2,3,4]
        let compare = try ints.map(to: NoNull.self).set
        XCTAssert(extracted == compare)
    }

    func testExtractSetOptional() throws {
        let node = try Node(node: ["nest": [ "ed": ["array": [1, 2, 3, 4]]]])
        let extracted: Set<NoNull>? = try node.extract("nest", "ed", "array")
        let ints = [1,2,3,4]
        let compare = try ints.map(to: NoNull.self).set
        XCTAssert(extracted == compare)
    }

    func testExtractSetThrows() throws {
        let node = EmptyNode
        do {
            _ = try node.extract("dont", "exist", 0) as Set<NoNull>
            XCTFail("should throw node error unable to convert")
        } catch NodeError.unableToConvert {}
    }
}

extension Date {
    static func fromTimestamp(_ timestamp: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }

    static func optionalFromTimestamp(_ timestamp: Int?) -> Date? {
        guard let stamp = timestamp else { return nil }
        return fromTimestamp(stamp)
    }
}
