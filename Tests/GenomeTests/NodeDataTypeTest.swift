//
//  NodeDataTypeTest.swift
//  Genome
//
//  Created by Logan Wright on 12/6/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest

@testable import Genome

class NodeDataTypeTest: XCTestCase {
    static let allTests = [
        ("testIntegers", testIntegers),
        ("testUnsignedIntegers", testUnsignedIntegers),
    ]

    // 127 is Int8 max, unless you want to change the way this test is setup,
    // the value must be somewhere between 0 and 127
    let integerValue: Int = 127
    lazy var integerNodeValue: Node = Node(Double(self.integerValue))

    func testIntegers() throws {
        
        let int = try Int(node: integerNodeValue)
        XCTAssertEqual(int, integerValue)
        
        let int8 = try Int8(node: integerNodeValue)
        XCTAssertEqual(int8, Int8(integerValue))
        
        let int16 = try Int16(node: integerNodeValue)
        XCTAssertEqual(int16, Int16(integerValue))
        
        let int32 = try Int32(node: integerNodeValue)
        XCTAssertEqual(int32, Int32(integerValue))
        
        let int64 = try Int64(node: integerNodeValue)
        XCTAssertEqual(int64, Int64(integerValue))
    }

    func testUnsignedIntegers() throws {
        let uint = try UInt(node: integerNodeValue)
        XCTAssertEqual(uint, UInt(integerValue))
        
        let uint8 = try UInt8(node: integerNodeValue)
        XCTAssertEqual(uint8, UInt8(integerValue))
        
        let uint16 = try UInt16(node: integerNodeValue)
        XCTAssertEqual(uint16, UInt16(integerValue))
        
        let uint32 = try UInt32(node: integerNodeValue)
        XCTAssertEqual(uint32, UInt32(integerValue))
        
        let uint64 = try UInt64(node: integerNodeValue)
        XCTAssertEqual(uint64, UInt64(integerValue))
    }
}
