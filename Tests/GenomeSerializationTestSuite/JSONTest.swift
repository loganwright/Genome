//
//  JSONTest.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/12/16.
//
//

import XCTest
import Foundation
@testable import GenomeSerialization

class JSONTest: XCTestCase {
    
    static var allTests: [(String, (BasicTypeTests) -> () throws -> Void)] {
        return [
                   ("testBasic", testBasic),
                   ("testBasicArrays", testBasicArrays)
        ]
    }
    
    let BasicTestString: String = "{\"int\" : 1,\n\"float\" : 1.5,\n\"double\" : 2.5,\n\"bool\" : true,\n\"string\" : \"hello\"}"

    let BasicTestNode: [String : Node] = [
                                             "int" : 1,
                                             "float" : 1.5,
                                             "double" : 2.5,
                                             "bool" : true,
                                             "string" : "hello"
    ]
    
    let basicArraysString: String = "{\"int\" : [1],\n\"float\" : [1.5],\n\"double\" : [2.5],\n\"bool\" : [true],\n\"string\" : [\"hello\"]}"
    
    let BasicArraysTestNode: [String : Node] = [
                                                   "ints" : [1],
                                                   "floats" : [1.5],
                                                   "doubles" : [2.5],
                                                   "bools" : [true],
                                                   "strings" : ["hello"]
    ]
    
    func testBasic() throws {
        let basic = try JSONDeserializer(data: BasicTestString).parse()
        guard case let Node.object(dictionary) = basic else {
            XCTFail("The expected output type is an object node.")
        }
        XCTAssert(dictionary["int"]!.int! == 1)
        XCTAssert(dictionary["float"]!.float! == 1.5)
        XCTAssert(dictionary["double"]!.double! == 2.5)
        XCTAssert(dictionary["bool"]!.bool! == true)
        XCTAssert(dictionary["string"]!.string! == "hello")
        
        let jsonString = try JSONSerializer(node: BasicTestNode)
        let jsonObject = try NSJSONSerialization.jsonObject(with: jsonString.data(using: NSUTF8StringEncoding), options: NSJSONReadingOptions(rawValue: 0)) as! [String: AnyObject]
        let int = jsonObject["int"] as! Int
        let float = jsonObject["float"] as! Float
        let double = jsonObject["double"] as! Double
        let bool = jsonObject["bool"] as! Bool
        let string = jsonObject["string"] as! String
        XCTAssert(int == 1)
        XCTAssert(float == 1.5)
        XCTAssert(double == 2.5)
        XCTAssert(bool == true)
        XCTAssert(string == "hello")
    }
    
    func testBasicArrays() throws {
        let basic = try JSONDeserializer(data: BasicTestString).parse()
        guard case let Node.object(dictionary) = basic else {
            XCTFail("The expected output type is an object node.")
        }
        XCTAssert(dictionary["int"]!.array.flatMap { $0.int! } == [1])
        XCTAssert(dictionary["float"]!.array.flatMap { $0.float! }  == [1.5])
        XCTAssert(dictionary["double"]!.array.flatMap { $0.double! } == [2.5])
        XCTAssert(dictionary["bool"]!.array.flatMap { $0.bool! } == [true])
        XCTAssert(dictionary["string"]!.array.flatMap { $0.string! } == ["hello"])
        
        let jsonString = try JSONSerializer(node: BasicArraysTestNode)
        let jsonObject = try NSJSONSerialization.jsonObject(with: jsonString.data(using: NSUTF8StringEncoding), options: NSJSONReadingOptions(rawValue: 0)) as! [String: AnyObject]
        let ints = jsonObject["ints"] as [Int]
        let floats = jsonObject["floats"] as [Float]
        let doubles = jsonObject["doubles"] as [Double]
        let bools = jsonObject["bools"] as [Bool]
        let strings = jsonObject["strings"] as [String]
        XCTAssert(ints == [1])
        XCTAssert(floats == [1.5])
        XCTAssert(doubles == [2.5])
        XCTAssert(bools == [true])
        XCTAssert(strings == ["hello"])
    }
    
    
    
}
