//
//  JSONTests.swift
//  Genome
//
//  Created by Logan Wright on 9/12/16.
//
//

import Foundation
//
//  BasicTypes.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import Foundation

import Genome
@testable import GenomeFoundation

class Person: BasicMappable {
    private(set) var name: String?
    private(set) var age: Int?
    private(set) var friend: Person?

    required init() {}

    func sequence(_ map: Map) throws {
        try name <~> map["name"]
        try age <~> map["age"]
        try friend <~> map["friend"]
    }
}

class JSONTests: XCTestCase {
    func testFoundationPerson() throws {
        let json: Any = [
            "name": "Foo Bar",
            "age": 162,
            "friend": [
                "name": "Friend Name",
                "age": 655
            ]
        ]
        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions(rawValue: 0))

        let person = try Person(node: data)
        XCTAssertEqual(person.name, "Foo Bar")
        XCTAssertEqual(person.age, 162)
        XCTAssertEqual(person.friend?.name, "Friend Name")
        XCTAssertEqual(person.friend?.age, 655)
    }

    func testFoundationPersonArray() throws {
        let json: [Any] = [
            [
                "name": "Foo Bar",
                "age": 162,
                "friend": [
                    "name": "Friend Name",
                    "age": 655
                ]
            ],
            [
                "name": "Foo Bar",
                "age": 162,
                "friend": [
                    "name": "Friend Name",
                    "age": 655
                ]
            ],
            [
                "name": "Foo Bar",
                "age": 162,
                "friend": [
                    "name": "Friend Name",
                    "age": 655
                ]
            ],
        ]
        let data = try JSONSerialization.data(
            withJSONObject: json,
            options: JSONSerialization.WritingOptions(rawValue: 0)
        )

        let people = try [Person](node: data)
        XCTAssertEqual(people.count, json.count)
        people.forEach { person in
            XCTAssertEqual(person.name, "Foo Bar")
            XCTAssertEqual(person.age, 162)
            XCTAssertEqual(person.friend?.name, "Friend Name")
            XCTAssertEqual(person.friend?.age, 655)
        }
//        XCTAssertEqual(person.name, "Foo Bar")
//        XCTAssertEqual(person.age, 162)
//        XCTAssertEqual(person.friend?.name, "Friend Name")
//        XCTAssertEqual(person.friend?.age, 655)
    }
/*
    func testFoundationInt() throws {
        let v = 235
        let n = Node(v as Any)
        XCTAssert(n.int == v)
    }

    func testFoundationDouble() throws {
        let v = 1.0
        let n = Node(v as Any)
        XCTAssert(n.double == v)
    }

    func testFoundationString() throws {
        let v = "hello foundation"
        let n = Node(v as Any)
        XCTAssert(n.string == v)
    }

    func testFoundationArray() throws {
        let v = [1,2,3,4,5]
        let n = Node(v as Any)
        let a = n.array ?? []
        XCTAssert(a.flatMap { $0.int } == v)
    }

    func testFoundationObject() throws {
        let v = [
            "hello" : "world"
        ]
        let n = Node(v as Any)
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
        let n = Node(v as Any)
        XCTAssert(n.isNull)
    }
 */
}
