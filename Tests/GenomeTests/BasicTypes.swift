//
//  BasicTypes.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
@testable import Genome

class BasicTypeTests: XCTestCase {
    static let allTests = [
        ("testBasic", testBasic),
        ("testBasicArrays", testBasicArrays)
    ]

    let BasicTestNode: [String : Node] = [
        "int" : 1,
        "float" : 1.5,
        "double" : 2.5,
        "bool" : true,
        "string" : "hello"
    ]
    
    struct Basic : BasicMappable, CustomStringConvertible {
        private(set) var int = 0
        private(set) var float: Float = 0
        private(set) var double: Double = 0
        private(set) var bool = false
        private(set) var string = ""
        
        mutating func sequence(_ map: Map) throws -> Void {
            let path: [String] = ["int"]
            try int <~> map[path]
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
        
        mutating func sequence(_ map: Map) throws -> Void {
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
        XCTAssertEqual(basic.int, 1)
        XCTAssertEqual(basic.float, 1.5)
        XCTAssertEqual(basic.double, 2.5)
        XCTAssertEqual(basic.bool, true)
        XCTAssertEqual(basic.string, "hello")
        
        let node = try basic.makeNode()
        let int = try node["int"].unwrap().int.unwrap()
        let float = try node["float"].unwrap().float.unwrap()
        let double = try node["double"].unwrap().double.unwrap()
        let bool = try node["bool"].unwrap().bool.unwrap()
        let string = try node["string"].unwrap().string.unwrap()
        XCTAssertEqual(int, 1)
        XCTAssertEqual(float, 1.5)
        XCTAssertEqual(double, 2.5)
        XCTAssertEqual(bool, true)
        XCTAssertEqual(string, "hello")
    }
    
    func testBasicArrays() throws {
        let basic = try BasicArrays(node: .object(BasicArraysTestNode))
        XCTAssertEqual(basic.ints, [1])
        XCTAssertEqual(basic.floats, [1.5])
        XCTAssertEqual(basic.doubles, [2.5])
        XCTAssertEqual(basic.bools, [true])
        XCTAssertEqual(basic.strings, ["hello"])
        
        let node = try basic.makeNode()
        let ints = try node["ints"].unwrap().array.unwrap().flatMap { $0.int }
        let floats = try node["floats"].unwrap().array.unwrap().flatMap { $0.float }
        let doubles = try node["doubles"].unwrap().array.unwrap().flatMap { $0.double }
        let bools = try node["bools"].unwrap().array.unwrap().flatMap { $0.bool }
        let strings = try node["strings"].unwrap().array.unwrap().flatMap { $0.string }
        XCTAssertEqual(ints, [1])
        XCTAssertEqual(floats, [1.5])
        XCTAssertEqual(doubles, [2.5])
        XCTAssertEqual(bools, [true])
        XCTAssertEqual(strings, ["hello"])
    }
}
