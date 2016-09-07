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

#if Xcode
class NodeFoundationTests: XCTestCase {
    func testFoundationBool() throws {
        let v = true
        let n = Node(v as AnyObject)
        XCTAssert(n.boolValue == v)
    }

    func testFoundationInt() throws {
        let v = 235
        let n = Node(v as AnyObject)
        XCTAssert(n.intValue == v)
    }

    func testFoundationDouble() throws {
        let v = 1.0
        let n = Node(v as AnyObject)
        XCTAssert(n.doubleValue == v)
    }

    func testFoundationString() throws {
        let v = "hello foundation"
        let n = Node(v as AnyObject)
        XCTAssert(n.string == v)
    }

    func testFoundationArray() throws {
        let v = [1,2,3,4,5]
        let n = Node(v as AnyObject)
        let a = n.arrayValue ?? []
        XCTAssert(a.flatMap { $0.intValue } == v)
    }

    func testFoundationObject() throws {
        let v = [
            "hello" : "world"
        ]
        let n = Node(v as AnyObject)
        let o = n.objectValue ?? [:]
        var mapped: [String : String] = [:]
        o.forEach { key, val in
            guard let str = val.string else { return }
            mapped[key] = str
        }
        XCTAssert(mapped == v)
    }

    func testFoundationNull() throws {
        let v = NSNull()
        let n = Node(v as AnyObject)
        XCTAssert(n.isNull)
    }
}
#endif
