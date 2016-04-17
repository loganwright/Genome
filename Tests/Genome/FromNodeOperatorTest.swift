//
//  FromNodeOperatorTest.swift
//  Genome
//
//  Created by Logan Wright on 9/22/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import Genome

class FromNodeOperatorTest: XCTestCase {
    
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
            try firstName = map.extract("first_name")
            try lastName = map.extract("last_name")
        }
        
        mutating func sequence(map: Map) throws -> Void {
            try firstName ~> map["first_name"]
            try lastName ~> map["last_name"]
        }
        
        var hashValue: Int {
            return firstName.hashValue ^ lastName.hashValue
        }
        
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
    
    lazy var node: [String : Node] = [
        "string" : "pass",
        "int" : 272,
        "strings" : self.strings,
        "person" : self.joeNode,
        "people" : [self.joeNode, self.janeNode],
        "duplicated_people" : [self.joeNode, self.joeNode, self.janeNode],
        "relationships" : [
            "best_friend" : self.philNode,
            "cousin" : self.justinNode
        ],
        "groups" : [
            "boys" : [self.joeNode, self.justinNode, self.philNode],
            "girls" : [self.janeNode]
        ],
        "ordered_groups" : [
            [self.joeNode, self.justinNode, self.philNode],
            [self.janeNode]
        ]
    ]
    
    lazy var map: Map = Map(node: Node.object(self.node))
    
    func testBasicTypes() {
        var string = ""
        try! string <~ map["string"]
        XCTAssert(string == "pass")
        
        var optionalString: String?
        try! optionalString <~ map["string"]
        XCTAssert(optionalString! == "pass")
        
        var strings: [String] = []
        try! strings <~ map["strings"]
        XCTAssert(strings == self.strings.arrayValue!.flatMap { $0.stringValue })
        
        var optionalStrings: [String]?
        try! optionalStrings <~ map["strings"]
        XCTAssert(optionalStrings! == self.strings.arrayValue!.flatMap { $0.stringValue })
        
        var emptyInt: Int?
        try! emptyInt <~ map["i_dont_exist"]
        XCTAssert(emptyInt == nil)
        
        var emptyStrings: [String]?
        try! emptyStrings <~ map["i_dont_exist"]
        XCTAssert(emptyStrings == nil)
    }
    
    func testMappableObject() {
        var person: Person = Person()
        try! person <~ map["person"]
        XCTAssert(person == self.joeObject)
        
        var optionalPerson: Person?
        try! optionalPerson <~ map["person"]
        XCTAssert(optionalPerson! == self.joeObject)
        
        var emptyPerson: Person?
        try! emptyPerson <~ map["i_dont_exist"]
        XCTAssert(emptyPerson == nil)
    }
    
    func testMappableArray() {
        var people: [Person] = []
        try! people <~ map["people"]
        XCTAssert(people == [self.joeObject, self.janeObject])
        
        var optionalPeople: [Person]?
        try! optionalPeople <~ map["people"]
        XCTAssert(optionalPeople! == [self.joeObject, self.janeObject])
        
        var emptyPersons: [Person]?
        try! emptyPersons <~ map["i_dont_exist"]
        XCTAssert(emptyPersons == nil)
    }
    
    func testMappableArrayOfArrays() {
        var orderedGroups: [[Person]] = []
        try! orderedGroups <~ map["ordered_groups"]
        XCTAssert(orderedGroups[0] == [self.joeObject, self.justinObject, self.philObject])
        XCTAssert(orderedGroups[1] == [self.janeObject])
        
        var optionalOrderedGroups: [[Person]]?
        try! optionalOrderedGroups <~ map["ordered_groups"]
        XCTAssert(optionalOrderedGroups![0] == [self.joeObject, self.justinObject, self.philObject])
        XCTAssert(optionalOrderedGroups![1] == [self.janeObject])
        
        var emptyOrderedGroups: [[Person]]?
        try! emptyOrderedGroups <~ map["i_dont_exist"]
        XCTAssert(emptyOrderedGroups == nil)
    }
    
    func testMappableDictionary() {
        let expectedRelationships = [
            "best_friend": self.philObject,
            "cousin": self.justinObject
        ]
        
        var relationships: [String : Person] = [:]
        try! relationships <~ map["relationships"]
        XCTAssert(relationships == expectedRelationships)
        
        var optionalRelationships: [String : Person]?
        try! optionalRelationships <~ map["relationships"]
        XCTAssert(optionalRelationships! == expectedRelationships)
        
        var emptyDictionary: [String : Person]?
        try! emptyDictionary <~ map["i_dont_exist"]
        XCTAssert(emptyDictionary == nil)
    }
    
    func testMappableDictionaryOfArrays() {
        var groups: [String : [Person]] = [:]
        try! groups <~ map["groups"]
        var optionalGroups: [String : [Person]]?
        try! optionalGroups <~ map["groups"]
        
        for groupsArray in [groups, optionalGroups!] {
            XCTAssert(groupsArray.count == 2)
            
            let boys = groupsArray["boys"]!
            XCTAssert(boys == [self.joeObject, self.justinObject, self.philObject])
            
            let girls = groupsArray["girls"]!
            XCTAssert(girls == [self.janeObject])
        }
        
        var emptyDictionaryOfArrays: [String : [Person]]?
        try! emptyDictionaryOfArrays <~ map["i_dont_exist"]
        XCTAssert(emptyDictionaryOfArrays == nil)
    }
    
    func testMappableSet() {
        var people: Set<Person> = Set<Person>()
        try! people <~ map["duplicated_people"]
        var optionalPeople: Set<Person>?
        try! optionalPeople <~ map["duplicated_people"]
        
        for peopleSet in [people, optionalPeople!] {
            XCTAssert(peopleSet.count == 2)
            XCTAssert(peopleSet.contains(self.joeObject))
            XCTAssert(peopleSet.contains(self.janeObject))
        }
        
        var singleValueToSet: Set<Person> = Set<Person>()
        try! singleValueToSet <~ map["person"]
        XCTAssert(singleValueToSet.count == 1)
        XCTAssert(singleValueToSet.contains(self.joeObject))
        
        var emptyPersons: [Person]?
        try! emptyPersons <~ map["i_dont_exist"]
        XCTAssert(emptyPersons == nil)
    }
    
}

// MARK: Operators

func ==(lhs: FromNodeOperatorTest.Person, rhs: FromNodeOperatorTest.Person) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
}
