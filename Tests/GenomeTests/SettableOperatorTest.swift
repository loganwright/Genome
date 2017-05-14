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
    static let allTests = [
        ("testBasicTypes", testBasicTypes),
        ("testMappableObject", testMappableObject),
        ("testMappableArray", testMappableArray),
        ("testMappableArrayOfArrays", testMappableArrayOfArrays),
        ("testMappableDictionary", testMappableDictionary),
        ("testMappableDictionaryOfArrays", testMappableDictionaryOfArrays),

        ("testMappableSet", testMappableSet),
        ("testDictionaryUnableToConvert", testDictionaryUnableToConvert),
        ("testDictArrayUnableToConvert", testDictArrayUnableToConvert),
        ("testThatValueExistsButIsNotTheTypeExpectedNonOptional", testThatValueExistsButIsNotTheTypeExpectedNonOptional),
        ("testThatValueExistsButIsNotTheTypeExpectedOptional", testThatValueExistsButIsNotTheTypeExpectedOptional),
        ("testThatValueDoesNotExistNonOptional", testThatValueDoesNotExistNonOptional),
        ("testMapType", testMapType),
    ]

    var map = makeTestMap()

    override func setUp() {
        super.setUp()
        map = makeTestMap()
    }

    func testBasicTypes() throws {
        let int: Int = try map.extract("int")
        XCTAssert(int == 272)
        
        let optionalInt: Int? = try map.extract("int")
        XCTAssert(optionalInt! == 272)
        
        let strings: [String] = try map.extract("strings")
        XCTAssert(strings == ["one", "two", "three"])
        
        let optionalStrings: [String]? = try map.extract("strings")
        XCTAssert(optionalStrings ?? [] == ["one", "two", "three"])
        
        let stringInt: String = try map.extract("int") { (nodeValue: Int) in
                return "\(nodeValue)"
        }
        XCTAssert(stringInt == "272")
        
        let emptyInt: Int? = try map.extract("i_dont_exist")
        XCTAssert(emptyInt == nil)
        
        let emptyStrings: [String]? = try map.extract("i_dont_exist")
        XCTAssert(emptyStrings == nil)
    }
    
    func testMappableObject() throws {
        let person: Person = try map.extract("person")
        XCTAssert(person == joeObject)
        
        let optionalPerson: Person? = try map.extract("person")
        XCTAssert(optionalPerson == joeObject)
        
        let emptyPerson: Person? = try map.extract("i_dont_exist")
        XCTAssert(emptyPerson == nil)
    }
    
    func testMappableArray() throws {
        let people: [Person] = try map.extract("people")
        XCTAssert(people == [joeObject, janeObject])
        
        let optionalPeople: [Person]? = try map.extract("people")
        XCTAssert(optionalPeople! == [joeObject, janeObject])
        
        let singleValueToArray: [Person] = try map.extract("person")
        XCTAssert(singleValueToArray == [joeObject])
        
        let emptyPersons: [Person]? = try map.extract("i_dont_exist")
        XCTAssert(emptyPersons == nil)
    }
    
    func testMappableArrayOfArrays() throws {
        let orderedGroups: [[Person]] = try map.extract("ordered_groups")
        let optionalOrderedGroups: [[Person]]? = try map.extract("ordered_groups")
        
        for orderGroupsArray in [orderedGroups, try optionalOrderedGroups.unwrap()] {
            XCTAssert(orderGroupsArray.count == 2)
            
            let firstGroup = orderGroupsArray[0]
            XCTAssert(firstGroup == [joeObject, justinObject, philObject])
            
            let secondGroup = orderGroupsArray[1]
            XCTAssert(secondGroup == [janeObject])
        }
        
        let arrayValueToArrayOfArrays: [[Person]] = try map.extract("people")
        XCTAssert(arrayValueToArrayOfArrays.count == 2)
        XCTAssert(arrayValueToArrayOfArrays.first! == [joeObject])
        
        let emptyArrayOfArrays: [[Person]]? = try map.extract("i_dont_exist")
        XCTAssert(emptyArrayOfArrays == nil)
    }
    
    func testMappableDictionary() throws {
        let expectedRelationships = [
            "best_friend": philObject,
            "cousin": justinObject
        ]
        
        let relationships: [String : Person] = try map.extract("relationships")
        XCTAssert(relationships == expectedRelationships)
        
        let optionalRelationships: [String : Person]? = try map.extract("relationships")
        XCTAssert(optionalRelationships! == expectedRelationships)
        
        let emptyDictionary: [String : Person]? = try map.extract("i_dont_exist")
        XCTAssert(emptyDictionary == nil)
    }
    
    func testMappableDictionaryOfArrays() throws {
        let groups: [String : [Person]] = try map.extract("groups")
        let optionalGroups: [String : [Person]]? = try map.extract("groups")
        
        for groupsArray in [groups, try optionalGroups.unwrap()] {
            XCTAssert(groupsArray.count == 2)
            
            let boys = try groupsArray["boys"].unwrap()
            XCTAssert(boys == [joeObject, justinObject, philObject])
            
            let girls = try groupsArray["girls"].unwrap()
            XCTAssert(girls == [janeObject])
        }
        
        let emptyDictionaryOfArrays: [String : [Person]]? = try map.extract("i_dont_exist")
        XCTAssert(emptyDictionaryOfArrays == nil)
    }
    
    func testMappableSet() throws {
        let people: Set<Person> = try map.extract("duplicated_people")
        let optionalPeople: Set<Person>? = try map.extract("duplicated_people")
        
        for peopleSet in [people, try optionalPeople.unwrap()] {
            XCTAssert(peopleSet.count == 2)
            XCTAssert(peopleSet.contains(joeObject))
            XCTAssert(peopleSet.contains(janeObject))
        }
        
        let singleValueToSet: Set<Person> = try map.extract("person")
        XCTAssert(singleValueToSet.count == 1)
        XCTAssert(singleValueToSet.contains(joeObject))
        
        let emptyPersons: [Person]? = try map.extract("i_dont_exist")
        XCTAssert(emptyPersons == nil)
    }

    func testDictionaryUnableToConvert() {
        do {
            let _: [String : Person] = try map.extract("int")
            XCTFail("Incorrect type should throw error")
        } catch NodeError.unableToConvert {
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
    }

    func testDictArrayUnableToConvert() {
        // Unexpected Type - Mappable Dictionary of Arrays
        do {
            let _: [String : [Person]] = try map.extract("int")
            XCTFail("Incorrect type should throw error")
        } catch NodeError.unableToConvert {
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
    }

    func testThatValueExistsButIsNotTheTypeExpectedNonOptional() {
        // Unexpected Type - Basic
        do {
            let _: Bool = try map.extract("int")
            XCTFail("Incorrect type should throw error")
        } catch let NodeError.unableToConvert(node: node, expected: expected) {
            XCTAssert(node == 272)
            XCTAssert(expected == "Bool")
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        
        // Unexpected Type - Mappable Object
        do {
            let _: Person = try map.extract("int")
            XCTFail("Incorrect type should throw error")
        } catch NodeError.unableToConvert {

        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        
        // Unexpected Type - Mappable Array
        do {
            let _: [Person] = try map.extract("int")
            XCTFail("Incorrect type should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }

        // Unexpected Type - Mappable Array of Arrays
        do {
            let _: [[Person]] = try map.extract("int")
            XCTFail("Incorrect type should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        
        // Unexpected Type - Transformable
        do {
            // Transformer expects string, but is passed an int
            let _: String = try map.extract("int") { (input: Bool) in
                    return "Hello: \(input)"
            }
            XCTFail("Incorrect type should throw error")
        }  catch let NodeError.unableToConvert(node: node, expected: expected) {
            XCTAssert(node == 272)
            XCTAssert(expected == "Bool")
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
    }
    
    // If a value exists, but is the wrong type, it should throw error
    func testThatValueExistsButIsNotTheTypeExpectedOptional() {
        // Unexpected Value - Mappable Object
        do {
            let _: Person? = try map.extract("int")
            XCTFail("Incorrect type should throw error")
        } catch NodeError.unableToConvert {

        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        // Unexpected Value - Mappable Array
        do {
            let _: [Person]? = try map.extract("int")
            XCTFail("Incorrect type should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        
        // Unexpected Value - Mappable Array of Arrays
        do {
            let _: [[Person]]? = try map.extract("int")
            XCTFail("Incorrect type should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        
        // Unexpected Value - Mappable Dictionary
        do {
            let _: [String : Person]? = try map.extract("int")
            XCTFail("Incorrect type should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        
        // Unexpected Value - Mappable Dictionary of Arrays
        do {
            let _: [String : [Person]]? = try map.extract("int")
            XCTFail("Incorrect type should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
    }
    
    // Expected Something, Got Nothing
    func testThatValueDoesNotExistNonOptional() {
        // Expected Non-Nil - Basic
        do {
            let _: String = try map.extract("asdf")
            XCTFail("nil value should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        
        // Expected Non-Nil - Mappable
        do {
            let _: Person = try map.extract("asdf")
            XCTFail("nil value should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        
        // Expected Non-Nil - Mappable Array
        do {
            let _: [Person] = try map.extract("asdf")
            XCTFail("nil value should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        
        // Expected Non-Nil - Mappable Array of Arrays
        do {
            let _: [[Person]] = try map.extract("asdf")
            XCTFail("nil value should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        
        // Expected Non-Nil - Mappable Dictionary
        do {
            let _: [String : Person] = try map.extract("asdf")
            XCTFail("nil value should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        
        // Expected Non-Nil - Mappable Dictionary of Arrays
        do {
            let _: [String : [Person]] = try map.extract("asdf")
            XCTFail("nil value should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
        
        // Expected Non-Nil - Transformable
        do {
            // Transformer expects string, but is passed an int
            let _: String = try map.extract("asdf") { (input: String) in
                    return "Hello: \(input)"
            }
            XCTFail("nil value should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
    }

    func testMapType() {
        do {
            let map = Map()
            let _: String = try map.extract("a")
            XCTFail("Inproper map type should throw error")
        } catch NodeError.unableToConvert {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(NodeError.unableToConvert)")
        }
    }
    
}
