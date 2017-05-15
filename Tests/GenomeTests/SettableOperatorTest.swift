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
        XCTAssertEqual(int, 272)
        
        let optionalInt: Int? = try map.extract("int")
        XCTAssertEqual(optionalInt, 272)
        
        let strings: [String] = try map.extract("strings")
        XCTAssertEqual(strings, ["one", "two", "three"])
        
        let optionalStrings: [String]? = try map.extract("strings")
        XCTAssertEqual(optionalStrings ?? [], ["one", "two", "three"])
        
        let stringInt: String = try map.extract("int") { (nodeValue: Int) in
                return "\(nodeValue)"
        }
        XCTAssertEqual(stringInt, "272")
        
        let emptyInt: Int? = try map.extract("i_dont_exist")
        XCTAssertNil(emptyInt)
        
        let emptyStrings: [String]? = try map.extract("i_dont_exist")
        XCTAssertNil(emptyStrings)
    }
    
    func testMappableObject() throws {
        let person: Person = try map.extract("person")
        XCTAssertEqual(person, joeObject)
        
        let optionalPerson: Person? = try map.extract("person")
        XCTAssertEqual(optionalPerson, joeObject)
        
        let emptyPerson: Person? = try map.extract("i_dont_exist")
        XCTAssertNil(emptyPerson)
    }
    
    func testMappableArray() throws {
        let people: [Person] = try map.extract("people")
        XCTAssertEqual(people, [joeObject, janeObject])
        
        let optionalPeople: [Person]? = try map.extract("people")
        XCTAssert(optionalPeople == [joeObject, janeObject])
        
        let singleValueToArray: [Person] = try map.extract("person")
        XCTAssertEqual(singleValueToArray, [joeObject])
        
        let emptyPersons: [Person]? = try map.extract("i_dont_exist")
        XCTAssertNil(emptyPersons)
    }
    
    func testMappableArrayOfArrays() throws {
        let orderedGroups: [[Person]] = try map.extract("ordered_groups")
        let optionalOrderedGroups: [[Person]]? = try map.extract("ordered_groups")
        
        for orderGroupsArray in [orderedGroups, try optionalOrderedGroups.unwrap()] {
            XCTAssertEqual(orderGroupsArray.count, 2)
            
            let firstGroup = orderGroupsArray[0]
            XCTAssertEqual(firstGroup, [joeObject, justinObject, philObject])
            
            let secondGroup = orderGroupsArray[1]
            XCTAssertEqual(secondGroup, [janeObject])
        }
        
        let arrayValueToArrayOfArrays: [[Person]] = try map.extract("people")
        XCTAssertEqual(arrayValueToArrayOfArrays.count, 2)
        XCTAssert(arrayValueToArrayOfArrays.first == [joeObject])
        
        let emptyArrayOfArrays: [[Person]]? = try map.extract("i_dont_exist")
        XCTAssertNil(emptyArrayOfArrays)
    }
    
    func testMappableDictionary() throws {
        let expectedRelationships = [
            "best_friend": philObject,
            "cousin": justinObject
        ]
        
        let relationships: [String : Person] = try map.extract("relationships")
        XCTAssertEqual(relationships, expectedRelationships)
        
        let optionalRelationships: [String : Person]? = try map.extract("relationships")
        XCTAssert(optionalRelationships == expectedRelationships)
        
        let emptyDictionary: [String : Person]? = try map.extract("i_dont_exist")
        XCTAssertNil(emptyDictionary)
    }
    
    func testMappableDictionaryOfArrays() throws {
        let groups: [String : [Person]] = try map.extract("groups")
        let optionalGroups: [String : [Person]]? = try map.extract("groups")
        
        for groupsArray in [groups, try optionalGroups.unwrap()] {
            XCTAssertEqual(groupsArray.count, 2)
            
            let boys = try groupsArray["boys"].unwrap()
            XCTAssertEqual(boys, [joeObject, justinObject, philObject])
            
            let girls = try groupsArray["girls"].unwrap()
            XCTAssertEqual(girls, [janeObject])
        }
        
        let emptyDictionaryOfArrays: [String : [Person]]? = try map.extract("i_dont_exist")
        XCTAssertNil(emptyDictionaryOfArrays)
    }
    
    func testMappableSet() throws {
        let people: Set<Person> = try map.extract("duplicated_people")
        let optionalPeople: Set<Person>? = try map.extract("duplicated_people")
        
        for peopleSet in [people, try optionalPeople.unwrap()] {
            XCTAssertEqual(peopleSet.count, 2)
            XCTAssert(peopleSet.contains(joeObject))
            XCTAssert(peopleSet.contains(janeObject))
        }
        
        let singleValueToSet: Set<Person> = try map.extract("person")
        XCTAssertEqual(singleValueToSet.count, 1)
        XCTAssert(singleValueToSet.contains(joeObject))
        
        let emptyPersons: [Person]? = try map.extract("i_dont_exist")
        XCTAssertNil(emptyPersons)
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
            XCTAssertEqual(node, 272)
            XCTAssertEqual(expected, "Bool")
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
            XCTAssertEqual(node, 272)
            XCTAssertEqual(expected, "Bool")
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
