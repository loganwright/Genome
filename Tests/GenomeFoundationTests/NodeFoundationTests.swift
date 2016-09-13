//
//  BasicTypes.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import Foundation
@testable import GenomeFoundation

class NodeFoundationTests: XCTestCase {
    func testFoundationBool() throws {
        let v = true
        let n = Node(any: v)
        XCTAssert(n.bool == v)
    }

    func testFoundationInt() throws {
        let v = 235
        let n = Node(any: v)
        XCTAssert(n.int == v)
    }

    func testFoundationDouble() throws {
        let v = 1.0
        let n = Node(any: v)
        XCTAssert(n.double == v)
    }

    func testFoundationString() throws {
        let v = "hello foundation"
        let n = Node(any: v)
        XCTAssert(n.string == v)
    }

    func testFoundationArray() throws {
        let v = [1,2,3,4,5]
        let n = Node(any: v)
        let a = n.array ?? []
        XCTAssert(a.flatMap { $0.int } == v)
    }

    func testFoundationObject() throws {
        let v = [
            "hello" : "world"
        ]
        let n = Node(any: v)
        let o = n.object ?? [:]
        var mapped: [String : String] = [:]
        o.forEach { key, val in
            guard let str = val.string else { return }
            mapped[key] = str
        }
        XCTAssert(mapped == v)
    }

    func testFoundationNull() throws {
        let v = NSNull()
        let n = Node(any: v)
        XCTAssert(n.isNull)
    }
}
