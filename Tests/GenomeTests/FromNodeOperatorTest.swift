//
//  FromNodeOperatorTest.swift
//  Genome
//
//  Created by Logan Wright on 9/22/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import Genome

struct Person: MappableObject, Hashable {

    let firstName: String
    let lastName: String

    init() {
        firstName = ""
        lastName = ""
    }

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }

    init(map: Map) throws {
        firstName = try map.extract("first_name")
        lastName = try map.extract("last_name")
    }

    mutating func sequence(_ map: Map) throws -> Void {
        try firstName ~> map["first_name"]
        try lastName ~> map["last_name"]
    }

    var hashValue: Int {
        return firstName.hashValue ^ lastName.hashValue
    }

}

func ==(lhs: Person, rhs: Person) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
}

let strings: Node = [
                        "one",
                        "two",
                        "tre"
]

let joeObject = Person(firstName: "Joe", lastName: "Fish")
let joeNode: Node = [
    "first_name" : "Joe",
    "last_name" : "Fish"
]

let janeObject = Person(firstName: "Jane", lastName: "Bear")
let janeNode: Node = [
    "first_name" : "Jane",
    "last_name" : "Bear"
]

let justinObject = Person(firstName: "Justin", lastName: "Badger")
let justinNode: Node = [
    "first_name" : "Justin",
    "last_name" : "Badger"
]

let philObject = Person(firstName: "Phil", lastName:"Viper")
let philNode: Node = [
    "first_name" : "Phil",
    "last_name" : "Viper"
]

let testNode: Node = [
    "string" : "pass",
    "int" : 272,
    "strings" : ["one", "two", "three"],
    "person" : joeNode,
    "people" :  [joeNode, janeNode],
    "duplicated_people" :  [joeNode, joeNode, janeNode],
    "relationships" : [
        "best_friend" : philNode,
        "cousin" : justinNode
    ],
    "groups" : [
        "boys" :  [joeNode, justinNode, philNode],
        "girls" :  [janeNode]
    ],
    "ordered_groups" : [
        [joeNode, justinNode, philNode],
        [janeNode]
    ]
]

func makeTestMap() -> Map {
    return Map(node: testNode)
}

class FromNodeOperatorTestBasic: XCTestCase {
    static let allTests = [
        ("testString", testString),
        ("testStringOptional", testStringOptional),
        ("testStringsArray", testStringsArray),
        ("testStringsArrayOptional", testStringsArrayOptional),
        ("testInt", testInt),
        ("testEmptyInt", testEmptyInt),
        ("testEmptyArray", testEmptyArray),
    ]

    let map = makeTestMap()

    func testString() throws {
        var string = ""
        try string <~ map["string"]
        XCTAssertEqual(string, "pass")
    }

    func testStringOptional() throws {
        var string: String? = nil
        try string <~ map["string"]
        XCTAssertEqual(string, "pass")
    }

    func testStringsArray() throws {
        var strings: [String] = []
        try strings <~ map["strings"]
        XCTAssertEqual(strings, ["one", "two", "three"])
    }

    func testStringsArrayOptional() throws {
        var strings: [String]? = nil
        try strings <~ map["strings"]
        XCTAssert(strings == ["one", "two", "three"])
    }

    func testInt() throws {
        var int = 0
        try int <~ map["int"]
        XCTAssertEqual(int, 272)
    }

    func testEmptyInt() throws {
        var wontExist: Int? = 0
        XCTAssertNotNil(wontExist)
        try wontExist <~ map["i-dont-exist"]
        XCTAssertNil(wontExist)
    }

    func testEmptyArray() throws {
        var wontExist: [String]? = []
        XCTAssertNotNil(wontExist)
        try wontExist <~ map["i-dont-exist"]
        XCTAssertNil(wontExist)
    }

}

class FromNodeOperatorTestMapped: XCTestCase {
    static let allTests = [
        ("testMappableObject", testMappableObject),
        ("testMappableArray", testMappableArray),
        ("testMappableArrayOfArrays", testMappableArrayOfArrays),
        ("testMappableDictionary", testMappableDictionary),
        ("testMappableDictionaryOfArrays", testMappableDictionaryOfArrays),
        ("testMappableSet", testMappableSet),
    ]

    let map = makeTestMap()

    func testMappableObject() throws {
        var person: Person = Person()
        try person <~ map["person"]
        XCTAssertEqual(person, joeObject)
        
        var optionalPerson: Person?
        try optionalPerson <~ map["person"]
        XCTAssertEqual(optionalPerson, joeObject)
        
        var emptyPerson: Person?
        try emptyPerson <~ map["i-dont-exist"]
        XCTAssertEqual(emptyPerson, nil)
    }
    
    func testMappableArray() throws {
        var people: [Person] = []
        try people <~ map["people"]
        XCTAssertEqual(people,  [joeObject, janeObject])
        
        var optionalPeople: [Person]?
        try optionalPeople <~ map["people"]
        XCTAssert(optionalPeople == [joeObject, janeObject])
        
        var emptyPersons: [Person]?
        try emptyPersons <~ map["i_dont_exist"]
        XCTAssertNil(emptyPersons)
    }
    
    func testMappableArrayOfArrays() throws {
        var orderedGroups: [[Person]] = []
        try orderedGroups <~ map["ordered_groups"]
        XCTAssertEqual(orderedGroups[0],  [joeObject, justinObject, philObject])
        XCTAssertEqual(orderedGroups[1],  [janeObject])
        
        var optionalOrderedGroups: [[Person]]?
        try optionalOrderedGroups <~ map["ordered_groups"]
        XCTAssert(optionalOrderedGroups?[0] == [joeObject, justinObject, philObject])
        XCTAssert(optionalOrderedGroups?[1] == [janeObject])
        
        var emptyOrderedGroups: [[Person]]?
        try emptyOrderedGroups <~ map["i_dont_exist"]
        XCTAssertNil(emptyOrderedGroups)
    }
    
    func testMappableDictionary() throws {
        let expectedRelationships = [
            "best_friend": philObject,
            "cousin": justinObject
        ]
        
        var relationships: [String : Person] = [:]
        try relationships <~ map["relationships"]
        XCTAssertEqual(relationships, expectedRelationships)
        
        var optionalRelationships: [String : Person]?
        try optionalRelationships <~ map["relationships"]
        XCTAssert(optionalRelationships == expectedRelationships)
        
        var emptyDictionary: [String : Person]?
        try emptyDictionary <~ map["i_dont_exist"]
        XCTAssertNil(emptyDictionary)
    }
    
    func testMappableDictionaryOfArrays() throws {
        var groups: [String : [Person]] = [:]
        try groups <~ map["groups"]
        var optionalGroups: [String : [Person]]?
        try optionalGroups <~ map["groups"]
        
        for groupsArray in [groups, try optionalGroups.unwrap()] {
            XCTAssertEqual(groupsArray.count, 2)
            
            let boys = try groupsArray["boys"].unwrap()
            XCTAssertEqual(boys,  [joeObject, justinObject, philObject])
            
            let girls = try groupsArray["girls"].unwrap()
            XCTAssertEqual(girls,  [janeObject])
        }
        
        var emptyDictionaryOfArrays: [String : [Person]]?
        try emptyDictionaryOfArrays <~ map["i_dont_exist"]
        XCTAssertNil(emptyDictionaryOfArrays)
    }
    
    func testMappableSet() throws {
        var people: Set<Person> = Set<Person>()
        try people <~ map["duplicated_people"]
        var optionalPeople: Set<Person>?
        try optionalPeople <~ map["duplicated_people"]
        
        for peopleSet in [people, try optionalPeople.unwrap()] {
            XCTAssertEqual(peopleSet.count, 2)
            XCTAssert(peopleSet.contains(joeObject))
            XCTAssert(peopleSet.contains(janeObject))
        }
        
        var singleValueToSet: Set<Person> = Set<Person>()
        try singleValueToSet <~ map["person"]
        XCTAssertEqual(singleValueToSet.count, 1)
        XCTAssert(singleValueToSet.contains(joeObject))
        
        var emptyPersons: [Person]?
        try emptyPersons <~ map["i_dont_exist"]
        XCTAssertNil(emptyPersons)
    }
    
}
