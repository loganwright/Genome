//
//  BasicTypes.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import Foundation

//import PureJsonSerializer
@testable import Genome

class BasicTypeTexts: XCTestCase {

    let BasicTestNode: [String : Node] = [
        "int" : 1,
        "float" : 1.5,
        "double" : 2.5,
        "bool" : true,
        "string" : "hello"
    ]
    
    struct Basic : BasicMappable, CustomStringConvertible {
        var int = 0
        var float: Float = 0
        var double: Double = 0
        var bool = false
        var string = ""
        
        mutating func sequence(map: Map) throws -> Void {
            try int <~> map["int"]
            try float <~> map["float"]
            try double <~> map["double"]
            try bool <~> map["bool"]
            try string <~> map["string"]
        }
        
        var description: String {
            return "\(int) : \(float) : \(double) : \(bool) : \(string)"
        }
    }
    
    let BasicArraysTestNode: [String : Node] = [
        "ints" : [1],
        "floats" : [1.5],
        "doubles" : [2.5],
        "bools" : [true],
        "strings" : ["hello"]
    ]
    
    struct BasicArrays : BasicMappable, CustomStringConvertible {
        var ints: [Int] = []
        var floats: [Float] = []
        var doubles: [Double] = []
        var bools: [Bool] = []
        var strings: [String] = []
        
        mutating func sequence(map: Map) throws -> Void {
            try ints <~> map["ints"]
            try floats <~> map["floats"]
            try doubles <~> map["doubles"]
            try bools <~> map["bools"]
            try strings <~> map["strings"]
        }
        
        var description: String {
            return "\(ints) : \(floats) : \(doubles) : \(bools) : \(strings)"
        }
    }
    
    func testBasic() throws {
        let basic = try Basic(node: BasicTestNode)
        XCTAssert(basic.int == 1)
        XCTAssert(basic.float == 1.5)
        XCTAssert(basic.double == 2.5)
        XCTAssert(basic.bool == true)
        XCTAssert(basic.string == "hello")
        
        let node = try basic.toNode()
        let int = node["int"]!.intValue!
        let float = node["float"]!.floatValue!
        let double = node["double"]!.doubleValue!
        let bool = node["bool"]!.boolValue!
        let string = node["string"]!.stringValue!
        XCTAssert(int == 1)
        XCTAssert(float == 1.5)
        XCTAssert(double == 2.5)
        XCTAssert(bool == true)
        XCTAssert(string == "hello")
    }
    
    func testBasicArrays() throws {
        let basic = try BasicArrays(node: .object(BasicArraysTestNode))
        XCTAssert(basic.ints == [1])
        XCTAssert(basic.floats == [1.5])
        XCTAssert(basic.doubles == [2.5])
        XCTAssert(basic.bools == [true])
        XCTAssert(basic.strings == ["hello"])
        
        let node = try basic.toNode()
        let ints = node["ints"]!.arrayValue!.flatMap { $0.intValue }
        let floats = node["floats"]!.arrayValue!.flatMap { $0.floatValue }
        let doubles = node["doubles"]!.arrayValue!.flatMap { $0.doubleValue }
        let bools = node["bools"]!.arrayValue!.flatMap { $0.boolValue }
        let strings = node["strings"]!.arrayValue!.flatMap { $0.stringValue }
        XCTAssert(ints == [1])
        XCTAssert(floats == [1.5])
        XCTAssert(doubles == [2.5])
        XCTAssert(bools == [true])
        XCTAssert(strings == ["hello"])
    }

    func testFoundationBool() throws {
        let v = true
        let n = try Node(v as AnyObject)
        XCTAssert(n.boolValue == v)
    }

    func testFoundationInt() throws {
        let v = 235
        let n = try Node(v as AnyObject)
        XCTAssert(n.intValue == v)
    }

    func testFoundationDouble() throws {
        let v = 1.0
        let n = try Node(v as AnyObject)
        XCTAssert(n.doubleValue == v)
    }

    func testFoundationString() throws {
        let v = "hello foundation"
        let n = try Node(v as AnyObject)
        XCTAssert(n.stringValue == v)
    }

    func testFoundationArray() throws {
        let v = [1,2,3,4,5]
        let n = try Node(v as AnyObject)
        let a = n.arrayValue ?? []
        XCTAssert(a.flatMap { $0.intValue } == v)
    }

    func testFoundationObject() throws {
        let v = [
            "hello" : "world"
        ]
        let n = try Node(v as AnyObject)
        let o = n.objectValue ?? [:]
        var mapped: [String : String] = [:]
        o.forEach { key, val in
            guard let str = val.stringValue else { return }
            mapped[key] = str
        }
        XCTAssert(mapped == v)
    }

    func testFoundationNull() throws {
        let v = NSNull()
        let n = try Node(v as AnyObject)
        XCTAssert(n.isNull)
    }
}

