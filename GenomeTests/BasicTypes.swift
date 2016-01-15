//
//  BasicTypes.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import Foundation
import PureJsonSerializer

@testable import Genome

class BasicTypeTexts: XCTestCase {

    let BasicTestJson: [String : Json] = [
        "int" : .from(1),
        "float" : .from(1.5),
        "double" : .from(2.5),
        "bool" : .from(true),
        "string" : .from("hello")
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
    
    let BasicArraysTestJson: [String : Json] = [
        "ints" : .from([1]),
        "floats" : .from([1.5]),
        "doubles" : .from([2.5]),
        "bools" : .from([true]),
        "strings" : .from(["hello"])
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
    
    func testBasic() {
        let basic = try! Basic(js: .ObjectValue(BasicTestJson))
        XCTAssert(basic.int == 1)
        XCTAssert(basic.float == 1.5)
        XCTAssert(basic.double == 2.5)
        XCTAssert(basic.bool == true)
        XCTAssert(basic.string == "hello")
        
        let json = try! basic.jsonRepresentation()
        let int = json["int"]!.intValue!
        let float = json["float"]!.floatValue!
        let double = json["double"]!.doubleValue!
        let bool = json["bool"]!.boolValue!
        let string = json["string"]!.stringValue!
        XCTAssert(int == 1)
        XCTAssert(float == 1.5)
        XCTAssert(double == 2.5)
        XCTAssert(bool == true)
        XCTAssert(string == "hello")
    }
    
    func testBasicArrays() {
        let basic = try! BasicArrays(js: .ObjectValue(BasicArraysTestJson))
        XCTAssert(basic.ints == [1])
        XCTAssert(basic.floats == [1.5])
        XCTAssert(basic.doubles == [2.5])
        XCTAssert(basic.bools == [true])
        XCTAssert(basic.strings == ["hello"])
        
        let json = try! basic.jsonRepresentation()
        let ints = json["ints"]!.arrayValue!.flatMap { $0.intValue }
        let floats = json["floats"]!.arrayValue!.flatMap { $0.floatValue }
        let doubles = json["doubles"]!.arrayValue!.flatMap { $0.doubleValue }
        let bools = json["bools"]!.arrayValue!.flatMap { $0.boolValue }
        let strings = json["strings"]!.arrayValue!.flatMap { $0.stringValue }
        XCTAssert(ints == [1])
        XCTAssert(floats == [1.5])
        XCTAssert(doubles == [2.5])
        XCTAssert(bools == [true])
        XCTAssert(strings == ["hello"])
    }
}

