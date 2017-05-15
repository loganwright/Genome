//
//  TransformTests.swift
//  Genome
//
//  Created by Logan Wright on 9/26/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest

@testable import Genome

class TransformTest: XCTestCase {
    static let allTests = [
        ("testTransform", testTransform)
    ]

    let testNode: Node = [
        "hello" : "world"
    ]
    
    func testTransform() throws {
        let map = Map(node: testNode)
        var settableString: String? = nil
        try settableString <~ map["hello"].transformFromNode { self.stringToString(input: $0) }
        XCTAssertEqual(settableString, "modified: world")
        
        let nonOptionalString = ""
        try nonOptionalString ~> map["test"].transformToNode(with: optStringToString)
    }
    
    func stringToString(input: String) -> String {
        return "modified: \(input)"
    }

    func optStringToString(input: String?) -> String {
        return "modified: \(input as Any)"
    }
}
