//
//  BasicTypes.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import Genome

class BasicTypeTexts: XCTestCase {

    let BasicTestJson = [
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
    
    let BasicArraysTestJson = [
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
    
    func test() {
        // This is an example of a performance test case.
        self.measureBlock() {
            self._testBasic()
            self._testBasicArrays()
        }
    }
    
    func _testBasic() {
        let basic = try! Basic.mappedInstance(BasicTestJson)
        XCTAssert(basic.int == 1)
        XCTAssert(basic.float == 1.5)
        XCTAssert(basic.double == 2.5)
        XCTAssert(basic.bool == true)
        XCTAssert(basic.string == "hello")
        
        let json = try! basic.jsonRepresentation()
        let int = json["int"] as! Int
        let float = json["float"] as! Float
        let double = json["double"] as! Double
        let bool = json["bool"] as! Bool
        let string = json["string"] as! String
        XCTAssert(int == 1)
        XCTAssert(float == 1.5)
        XCTAssert(double == 2.5)
        XCTAssert(bool == true)
        XCTAssert(string == "hello")
    }
    
    func _testBasicArrays() {
        let basic = try! BasicArrays.mappedInstance(BasicArraysTestJson)
        XCTAssert(basic.ints == [1])
        XCTAssert(basic.floats == [1.5])
        XCTAssert(basic.doubles == [2.5])
        XCTAssert(basic.bools == [true])
        XCTAssert(basic.strings == ["hello"])
        
        let json = try! basic.jsonRepresentation()
        let ints = json["ints"] as! [Int]
        let floats = json["floats"] as! [Float]
        let doubles = json["doubles"] as! [Double]
        let bools = json["bools"] as! [Bool]
        let strings = json["strings"] as! [String]
        XCTAssert(ints == [1])
        XCTAssert(floats == [1.5])
        XCTAssert(doubles == [2.5])
        XCTAssert(bools == [true])
        XCTAssert(strings == ["hello"])
    }
}

