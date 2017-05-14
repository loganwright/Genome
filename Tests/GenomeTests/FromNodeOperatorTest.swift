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
        XCTAssert(string == "pass")
    }

    func testStringOptional() throws {
        var string: String? = nil
        try string <~ map["string"]
        XCTAssert(string == "pass")
    }

    func testStringsArray() throws {
        var strings: [String] = []
        try strings <~ map["strings"]
        XCTAssert(strings == ["one", "two", "three"])
    }

    func testStringsArrayOptional() throws {
        var strings: [String]? = nil
        try strings <~ map["strings"]
        XCTAssert(strings! == ["one", "two", "three"])
    }

    func testInt() throws {
        var int = 0
        try int <~ map["int"]
        XCTAssert(int == 272)
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
        XCTAssert(person == joeObject)
        
        var optionalPerson: Person?
        try optionalPerson <~ map["person"]
        XCTAssert(optionalPerson! == joeObject)
        
        var emptyPerson: Person?
        try emptyPerson <~ map["i-dont-exist"]
        XCTAssert(emptyPerson == nil)
    }
    
    func testMappableArray() throws {
        var people: [Person] = []
        try people <~ map["people"]
        XCTAssert(people ==  [joeObject, janeObject])
        
        var optionalPeople: [Person]?
        try optionalPeople <~ map["people"]
        XCTAssert(optionalPeople! ==  [joeObject, janeObject])
        
        var emptyPersons: [Person]?
        try emptyPersons <~ map["i_dont_exist"]
        XCTAssert(emptyPersons == nil)
    }
    
    func testMappableArrayOfArrays() throws {
        var orderedGroups: [[Person]] = []
        try orderedGroups <~ map["ordered_groups"]
        XCTAssert(orderedGroups[0] ==  [joeObject, justinObject, philObject])
        XCTAssert(orderedGroups[1] ==  [janeObject])
        
        var optionalOrderedGroups: [[Person]]?
        try optionalOrderedGroups <~ map["ordered_groups"]
        XCTAssert(optionalOrderedGroups![0] ==  [joeObject, justinObject, philObject])
        XCTAssert(optionalOrderedGroups![1] ==  [janeObject])
        
        var emptyOrderedGroups: [[Person]]?
        try emptyOrderedGroups <~ map["i_dont_exist"]
        XCTAssert(emptyOrderedGroups == nil)
    }
    
    func testMappableDictionary() throws {
        let expectedRelationships = [
            "best_friend": philObject,
            "cousin": justinObject
        ]
        
        var relationships: [String : Person] = [:]
        try relationships <~ map["relationships"]
        XCTAssert(relationships == expectedRelationships)
        
        var optionalRelationships: [String : Person]?
        try optionalRelationships <~ map["relationships"]
        XCTAssert(optionalRelationships! == expectedRelationships)
        
        var emptyDictionary: [String : Person]?
        try emptyDictionary <~ map["i_dont_exist"]
        XCTAssert(emptyDictionary == nil)
    }
    
    func testMappableDictionaryOfArrays() throws {
        var groups: [String : [Person]] = [:]
        try groups <~ map["groups"]
        var optionalGroups: [String : [Person]]?
        try optionalGroups <~ map["groups"]
        
        for groupsArray in [groups, try optionalGroups.unwrap()] {
            XCTAssert(groupsArray.count == 2)
            
            let boys = try groupsArray["boys"].unwrap()
            XCTAssert(boys ==  [joeObject, justinObject, philObject])
            
            let girls = try groupsArray["girls"].unwrap()
            XCTAssert(girls ==  [janeObject])
        }
        
        var emptyDictionaryOfArrays: [String : [Person]]?
        try emptyDictionaryOfArrays <~ map["i_dont_exist"]
        XCTAssert(emptyDictionaryOfArrays == nil)
    }
    
    func testMappableSet() throws {
        var people: Set<Person> = Set<Person>()
        try people <~ map["duplicated_people"]
        var optionalPeople: Set<Person>?
        try optionalPeople <~ map["duplicated_people"]
        
        for peopleSet in [people, try optionalPeople.unwrap()] {
            XCTAssert(peopleSet.count == 2)
            XCTAssert(peopleSet.contains(joeObject))
            XCTAssert(peopleSet.contains(janeObject))
        }
        
        var singleValueToSet: Set<Person> = Set<Person>()
        try singleValueToSet <~ map["person"]
        XCTAssert(singleValueToSet.count == 1)
        XCTAssert(singleValueToSet.contains(joeObject))
        
        var emptyPersons: [Person]?
        try emptyPersons <~ map["i_dont_exist"]
        XCTAssert(emptyPersons == nil)
    }
    
}
