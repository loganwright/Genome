import Foundation
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
        let data = try JSONSerialization.data(
            withJSONObject: json,
            options: .init(rawValue: 0)
        )

        let person = try Person(node: data)
        XCTAssertEqual(person.name, "Foo Bar")
        XCTAssertEqual(person.age, 162)
        XCTAssertEqual(person.friend?.name, "Friend Name")
        XCTAssertEqual(person.friend?.age, 655)

        let back = try Data(node: person)
        XCTAssertEqual(data, back)
    }

    func testFoundationPersonArray() throws {
        let json: Any = [
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
        XCTAssertEqual(people.count, 3)
        people.forEach { person in
            XCTAssertEqual(person.name, "Foo Bar")
            XCTAssertEqual(person.age, 162)
            XCTAssertEqual(person.friend?.name, "Friend Name")
            XCTAssertEqual(person.friend?.age, 655)
        }

        let back = try Data.init(node: people)
        XCTAssertEqual(data, back)
    }
}
