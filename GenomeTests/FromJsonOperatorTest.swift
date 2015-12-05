//
//  FromJsonOperatorTest.swift
//  Genome
//
//  Created by Logan Wright on 9/22/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import Genome

class FromJsonOperatorTest: XCTestCase {
    
    struct Person: StandardMappable, Hashable {
        
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
            try firstName = <~map["first_name"]
            try lastName = <~map["last_name"]
        }
        
        mutating func sequence(map: Map) throws -> Void {
            try firstName ~> map["first_name"]
            try lastName ~> map["last_name"]
        }
        
        var hashValue: Int {
            return firstName.hashValue ^ lastName.hashValue
        }
        
    }
    
    let strings = [
        "one",
        "two",
        "tre"
    ]
    
    let joeObject = Person(firstName: "Joe", lastName: "Fish")
    let joeJson = [
        "first_name" : "Joe",
        "last_name" : "Fish"
    ]
    
    let janeObject = Person(firstName: "Jane", lastName: "Bear")
    let janeJson = [
        "first_name" : "Jane",
        "last_name" : "Bear"
    ]
    
    let justinObject = Person(firstName: "Justin", lastName: "Badger")
    let justinJson = [
        "first_name" : "Justin",
        "last_name" : "Badger"
    ]
    
    let philObject = Person(firstName: "Phil", lastName:"Viper")
    let philJson = [
        "first_name" : "Phil",
        "last_name" : "Viper"
    ]
    
    lazy var json: JSON = [
        "string" : "pass",
        "int" : 272,
        "strings" : self.strings,
        "person" : self.joeJson,
        "people" : [self.joeJson, self.janeJson],
        "duplicated_people" : [self.joeJson, self.joeJson, self.janeJson],
        "relationships" : [
            "best_friend" : self.philJson,
            "cousin" : self.justinJson
        ],
        "groups" : [
            "boys" : [self.joeJson, self.justinJson, self.philJson],
            "girls" : [self.janeJson]
        ],
        "ordered_groups" : [
            [self.joeJson, self.justinJson, self.philJson],
            [self.janeJson]
        ]
    ]
    
    lazy var map: Map = Map(json: self.json)
    
    func testBasicTypes() {
        var string = ""
        try! string <~ map["string"]
        XCTAssert(string == "pass")
        
        var optionalString: String?
        try! optionalString <~ map["string"]
        XCTAssert(optionalString! == "pass")
        
        var strings: [String] = []
        try! strings <~ map["strings"]
        XCTAssert(strings == self.strings)
        
        var optionalStrings: [String]?
        try! optionalStrings <~ map["strings"]
        XCTAssert(optionalStrings! == self.strings)
        
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

func ==(lhs: FromJsonOperatorTest.Person, rhs: FromJsonOperatorTest.Person) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
}
