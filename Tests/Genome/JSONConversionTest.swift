//
//  JSONConversionTest.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/10/16.
//
//

import XCTest
@testable import Genome

class JSONConversionTest: XCTestCase {

    let testObject: Node = Node.object([
                                                "unescapedString": .string("The quick brown fox jumped over the lazy dog."),
                                                "escapingString": .string("\t\r\n\u{0C}\u{08}/\\\""),
                                                "unicodeCharacter": .string("😀"),
                                                "integer": .number(3.0),
                                                "negativeInteger": .number(-5.0),
                                                "largeInteger": .number(70000),
                                                "decimal": .number(2.11),
                                                "negativeDecimal": .number(-6.59),
                                                "exponentedDecimal": .number(1.23),
                                                "decimalWithExponent": .number(4560),
                                                "justDecimal": .number(0.17),
                                                "array": .array([.string("A"), .string("B"), .string("C"), .string("D")]),
                                                "subObject": .object(["a": .string("A"), "b": .string("B"), "c": .string("C"), "d": .string("D")]),
                                                "true": .bool(true),
                                                "false": .bool(false),
                                                "null": .null
        ])
    
    /*func testDeserialization() {
        let dataPath = NSBundle.main().pathForResource("Test", ofType: "json")!
        let rawData = try! NSString(contentsOfFile: dataPath, encoding: NSUTF8StringEncoding) as String
        let data = try! JSONDeserializer.deserialize(rawData)
        XCTAssert(data == testObject)
    }*/
    
    func testSerialization() {
        let data: String = try! JSONSerializer(node: testObject).parse()!
        // TODO: A better way to test this is needed, as dictionary order is not guaranteed.
        let stringRepresentation = "{\"decimal\":2.11,\"integer\":3,\"unicodeCharacter\":\"😀\",\"justDecimal\":0.17,\"subObject\":{\"b\":\"B\",\"d\":\"D\",\"c\":\"C\",\"a\":\"A\"},\"negativeInteger\":-5,\"true\":true,\"unescapedString\":\"The quick brown fox jumped over the lazy dog.\",\"exponentedDecimal\":1.23,\"negativeDecimal\":-6.59,\"null\":null,\"false\":false,\"escapingString\":\"\\t\\r\\n\\u000c\\b\\/\\\"\",\"array\":[\"A\",\"B\",\"C\",\"D\"],\"largeInteger\":70000.0,\"decimalWithExponent\":4560.0}"
        XCTAssert(data == stringRepresentation)
    }
    
}
