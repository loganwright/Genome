//
//  BasicTypes.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import Foundation

@testable import Genome

class BasicTypeTexts: XCTestCase {

    let BasicTestDna: [String : Dna] = [
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
    
    let BasicArraysTestDna: [String : Dna] = [
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
        let basic = try! Basic(dna: .ObjectValue(BasicTestDna))
        XCTAssert(basic.int == 1)
        XCTAssert(basic.float == 1.5)
        XCTAssert(basic.double == 2.5)
        XCTAssert(basic.bool == true)
        XCTAssert(basic.string == "hello")
        
        let dna = try! basic.dnaRepresentation()
        let int = dna["int"]!.intValue!
        let float = dna["float"]!.floatValue!
        let double = dna["double"]!.doubleValue!
        let bool = dna["bool"]!.boolValue!
        let string = dna["string"]!.stringValue!
        XCTAssert(int == 1)
        XCTAssert(float == 1.5)
        XCTAssert(double == 2.5)
        XCTAssert(bool == true)
        XCTAssert(string == "hello")
    }
    
    func testBasicArrays() {
        let basic = try! BasicArrays(dna: .ObjectValue(BasicArraysTestDna))
        XCTAssert(basic.ints == [1])
        XCTAssert(basic.floats == [1.5])
        XCTAssert(basic.doubles == [2.5])
        XCTAssert(basic.bools == [true])
        XCTAssert(basic.strings == ["hello"])
        
        let dna = try! basic.dnaRepresentation()
        let ints = dna["ints"]!.arrayValue!.flatMap { $0.intValue }
        let floats = dna["floats"]!.arrayValue!.flatMap { $0.floatValue }
        let doubles = dna["doubles"]!.arrayValue!.flatMap { $0.doubleValue }
        let bools = dna["bools"]!.arrayValue!.flatMap { $0.boolValue }
        let strings = dna["strings"]!.arrayValue!.flatMap { $0.stringValue }
        XCTAssert(ints == [1])
        XCTAssert(floats == [1.5])
        XCTAssert(doubles == [2.5])
        XCTAssert(bools == [true])
        XCTAssert(strings == ["hello"])
    }
}

