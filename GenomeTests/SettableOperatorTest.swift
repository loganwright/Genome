//
//  SettableOperatorTest.swift
//  Genome
//
//  Created by Logan Wright on 9/22/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
@testable import Genome

class SettableOperatorTest: XCTestCase {
    
    struct Person: StandardMappable, Hashable {
        
        let firstName: String
        let lastName: String
        
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
    
    lazy var map: Map! = Map(json: self.json)
    
    override func tearDown() {
        map = nil
    }
    
    func testBasicTypes() {
        let int: Int = try! <~map["int"]
        XCTAssert(int == 272)
        
        let optionalInt: Int? = try! map["int"]
            .extract()
        XCTAssert(optionalInt! == 272)
        
        let strings: [String] = try! map["strings"]
            .extract()
        XCTAssert(strings == self.strings)
        
        let optionalStrings: [String]? = try! map["strings"]
        .extract()
        XCTAssert(optionalStrings! == self.strings)
        
        let stringInt: String = try! <~map["int"]
            .transformFromJson { (jsonValue: Int) in
                return "\(jsonValue)"
        }
        XCTAssert(stringInt == "272")
        
        let emptyInt: Int? = try! map["i_dont_exist"]
        .extract()
        XCTAssert(emptyInt == nil)
        
        let emptyStrings: [String]? = try! map["i_dont_exist"]
                .extract()
        XCTAssert(emptyStrings == nil)
    }
    
    func testMappableObject() {
        let person: Person = try! <~map["person"]
        XCTAssert(person == self.joeObject)
        
        let optionalPerson: Person? = try! map["person"]
            .extract()
        XCTAssert(optionalPerson == self.joeObject)
        
        let emptyPerson: Person? = try! map["i_dont_exist"]
            .extract()
        XCTAssert(emptyPerson == nil)
    }
    
    func testMappableArray() {
        let people: [Person] = try! <~map["people"]
        XCTAssert(people == [self.joeObject, self.janeObject])
        
        let optionalPeople: [Person]? = try! <~?map["people"]
        XCTAssert(optionalPeople! == [self.joeObject, self.janeObject])
        
        let singleValueToArray: [Person] = try! <~map["person"]
        XCTAssert(singleValueToArray == [self.joeObject])
        
        let emptyPersons: [Person]? = try! <~?map["i_dont_exist"]
        XCTAssert(emptyPersons == nil)
    }
    
    func testMappableArrayOfArrays() {
        let orderedGroups: [[Person]] = try! <~map["ordered_groups"]
        let optionalOrderedGroups: [[Person]]? = try! <~?map["ordered_groups"]
        
        for orderGroupsArray in [orderedGroups, optionalOrderedGroups!] {
            XCTAssert(orderGroupsArray.count == 2)
            
            let firstGroup = orderGroupsArray[0]
            XCTAssert(firstGroup == [self.joeObject, self.justinObject, self.philObject])
            
            let secondGroup = orderGroupsArray[1]
            XCTAssert(secondGroup == [self.janeObject])
        }
        
        let arrayValueToArrayOfArrays: [[Person]] = try! <~map["people"]
        XCTAssert(arrayValueToArrayOfArrays.count == 1)
        XCTAssert(arrayValueToArrayOfArrays.first! == [self.joeObject, self.janeObject])
        
        let emptyArrayOfArrays: [[Person]]? = try! <~?map["i_dont_exist"]
        XCTAssert(emptyArrayOfArrays == nil)
    }
    
    func testMappableDictionary() {
        let expectedRelationships = [
            "best_friend": self.philObject,
            "cousin": self.justinObject
        ]
        
        let relationships: [String : Person] = try! <~map["relationships"]
        XCTAssert(relationships == expectedRelationships)
        
        let optionalRelationships: [String : Person]? = try! <~?map["relationships"]
        XCTAssert(optionalRelationships! == expectedRelationships)
        
        let emptyDictionary: [String : Person]? = try! <~?map["i_dont_exist"]
        XCTAssert(emptyDictionary == nil)
    }
    
    func testMappableDictionaryOfArrays() {
        let groups: [String : [Person]] = try! <~map["groups"]
        let optionalGroups: [String : [Person]]? = try! <~?map["groups"]
        
        for groupsArray in [groups, optionalGroups!] {
            XCTAssert(groupsArray.count == 2)
            
            let boys = groupsArray["boys"]!
            XCTAssert(boys == [self.joeObject, self.justinObject, self.philObject])
            
            let girls = groupsArray["girls"]!
            XCTAssert(girls == [self.janeObject])
        }
        
        let emptyDictionaryOfArrays: [String : [Person]]? = try! <~?map["i_dont_exist"]
        XCTAssert(emptyDictionaryOfArrays == nil)
    }
    
    func testMappableSet() {
        let people: Set<Person> = try! <~map["duplicated_people"]
        let optionalPeople: Set<Person>? = try! <~?map["duplicated_people"]
        
        for peopleSet in [people, optionalPeople!] {
            XCTAssert(peopleSet.count == 2)
            XCTAssert(peopleSet.contains(self.joeObject))
            XCTAssert(peopleSet.contains(self.janeObject))
        }
        
        let singleValueToSet: Set<Person> = try! <~map["person"]
        XCTAssert(singleValueToSet.count == 1)
        XCTAssert(singleValueToSet.contains(self.joeObject))
        
        let emptyPersons: [Person]? = try! <~?map["i_dont_exist"]
        XCTAssert(emptyPersons == nil)
    }
    
    func testThatValueExistsButIsNotTheTypeExpectedNonOptional() {
        // Unexpected Type - Basic
//        do {
//            let _: String = try <~map["int"]
//            XCTFail("Incorrect type should throw error")
//        } catch SequenceError.UnexpectedValue(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
//        }
//        
//        // Unexpected Type - Mappable Object
//        do {
//            let _: Person = try <~map["int"]
//            XCTFail("Incorrect type should throw error")
//        } catch SequenceError.UnexpectedValue(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
//        }
//        
//        // Unexpected Type - Mappable Array
//        do {
//            let _: [Person] = try <~map["int"]
//            XCTFail("Incorrect type should throw error")
//        } catch SequenceError.UnexpectedValue(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
//        }
//        
//        // Unexpected Type - Mappable Array of Arrays
//        do {
//            let _: [[Person]] = try <~map["int"]
//            XCTFail("Incorrect type should throw error")
//        } catch SequenceError.UnexpectedValue(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
//        }
//        
//        // Unexpected Type - Mappable Dictionary
//        do {
//            let _: [String : Person] = try <~map["int"]
//            XCTFail("Incorrect type should throw error")
//        } catch SequenceError.UnexpectedValue(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
//        }
//        
//        // Unexpected Type - Mappable Dictionary of Arrays
//        do {
//            let _: [String : [Person]] = try <~map["int"]
//            XCTFail("Incorrect type should throw error")
//        } catch SequenceError.UnexpectedValue(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
//        }
//        
//        // Unexpected Type - Transformable
//        do {
//            // Transformer expects string, but is passed an int
//            let _: String = try <~map["int"]
//                .transformFromJson { (input: String) in
//                    return "Hello: \(input)"
//            }
//            XCTFail("Incorrect type should throw error")
//        } catch TransformationError.UnexpectedInputType(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(TransformationError.UnexpectedInputType)")
//        }
    }
    
    // If a value exists, but is the wrong type, it should throw error
    func testThatValueExistsButIsNotTheTypeExpectedOptional() {
        // Unexpected Value - Basic
//        do {
//            let _: String? = try <~?map["int"]
//            XCTFail("Incorrect type should throw error")
//        } catch SequenceError.UnexpectedValue(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
//        }
//        
//        // Unexpected Value - Mappable Object
//        do {
//            let _: Person? = try <~?map["int"]
//            XCTFail("Incorrect type should throw error")
//        } catch SequenceError.UnexpectedValue(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
//        }
//        
//        // Unexpected Value - Mappable Array
//        do {
//            let _: [Person]? = try <~?map["int"]
//            XCTFail("Incorrect type should throw error")
//        } catch SequenceError.UnexpectedValue(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
//        }
//        
//        // Unexpected Value - Mappable Array of Arrays
//        do {
//            let _: [[Person]]? = try <~?map["int"]
//            XCTFail("Incorrect type should throw error")
//        } catch SequenceError.UnexpectedValue(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
//        }
//        
//        // Unexpected Value - Mappable Dictionary
//        do {
//            let _: [String : Person]? = try <~?map["int"]
//            XCTFail("Incorrect type should throw error")
//        } catch SequenceError.UnexpectedValue(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
//        }
//        
//        // Unexpected Value - Mappable Dictionary of Arrays
//        do {
//            let _: [String : [Person]]? = try <~?map["int"]
//            XCTFail("Incorrect type should throw error")
//        } catch SequenceError.UnexpectedValue(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
//        }
//        
//        // Unexpected Input Type (nil) - Transformable
//        do {
//            // Transformer expects string, but is passed an int
//            let _: String? = try <~map["int"]
//                .transformFromJson { (input: String?) in
//                    return "Hello: \(input)"
//            }
//            XCTFail("Incorrect type should throw error")
//        } catch TransformationError.UnexpectedInputType(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(TransformationError.UnexpectedInputType)")
//        }
        
    }
    
    // Expected Something, Got Nothing
    func testThatValueDoesNotExistNonOptional() {
        // Expected Non-Nil - Basic
//        do {
//            let _: String = try <~map["asdf"]
//            XCTFail("nil value should throw error")
//        } catch SequenceError.FoundNil(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.FoundNil)")
//        }
//        
//        // Expected Non-Nil - Mappable
//        do {
//            let _: Person = try <~map["asdf"]
//            XCTFail("nil value should throw error")
//        } catch SequenceError.FoundNil(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.FoundNil)")
//        }
//        
//        // Expected Non-Nil - Mappable Array
//        do {
//            let _: [Person] = try <~map["asdf"]
//            XCTFail("nil value should throw error")
//        } catch SequenceError.FoundNil(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.FoundNil)")
//        }
//        
//        // Expected Non-Nil - Mappable Array of Arrays
//        do {
//            let _: [[Person]] = try <~map["asdf"]
//            XCTFail("nil value should throw error")
//        } catch SequenceError.FoundNil(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.FoundNil)")
//        }
//        
//        // Expected Non-Nil - Mappable Dictionary
//        do {
//            let _: [String : Person] = try <~map["asdf"]
//            XCTFail("nil value should throw error")
//        } catch SequenceError.FoundNil(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.FoundNil)")
//        }
//        
//        // Expected Non-Nil - Mappable Dictionary of Arrays
//        do {
//            let _: [String : [Person]] = try <~map["asdf"]
//            XCTFail("nil value should throw error")
//        } catch SequenceError.FoundNil(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.FoundNil)")
//        }
//        
//        // Expected Non-Nil - Transformable
//        do {
//            // Transformer expects string, but is passed an int
//            let _: String = try <~map["asdf"]
//                .transformFromJson { (input: String) in
//                    return "Hello: \(input)"
//            }
//            XCTFail("nil value should throw error")
//        } catch TransformationError.UnexpectedInputType(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(TransformationError.UnexpectedInputType)")
//        }
    }
    
    func testMapType() {
//        do {
//            map.type = .ToJson
//            let _: String = try <~map["a"]
//            XCTFail("Inproper map type should throw error")
//        } catch MappingError.UnexpectedOperationType(_) {
//            
//        } catch {
//            XCTFail("Incorrect Error: \(error) Expected: \(MappingError.UnexpectedOperationType)")
//        }
        
    }
    
}

// MARK: Operators

func ==(lhs: SettableOperatorTest.Person, rhs: SettableOperatorTest.Person) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
}
