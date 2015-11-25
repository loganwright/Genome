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

    struct Person : StandardMappable {
        let firstName: String
        let lastName: String

        init(map: Map) throws {
            try firstName = <~map["first_name"]
            try lastName = <~map["last_name"]
        }
        
        mutating func sequence(map: Map) throws -> Void {
            try firstName ~> map["first_name"]
            try lastName ~> map["last_name"]
        }
    }
    
    let strings = [
        "one",
        "two",
        "tre"
    ]
    
    let joe = [
        "first_name" : "Joe",
        "last_name" : "Fish"
    ]
    let jane = [
        "first_name" : "Jane",
        "last_name" : "Bear"
    ]
    
    lazy var json: JSON = [
        "int" : 272,
        "strings" : self.strings,
        "person" : self.joe,
        "people" : [
            self.joe,
            self.jane
        ]
    ]
    
    lazy var map: Map! = Map(json: self.json)

    override func tearDown() {
        map = nil
    }
    
    func test() {
        let int: Int = try! <~map["int"]
        XCTAssert(int == 272)
        
        let optionalInt: Int? = try! <~?map["int"]
        XCTAssert(optionalInt! == 272)
        
        let strings: [String] = try! <~map["strings"]
        XCTAssert(strings == self.strings)
        
        let optionalStrings: [String]? = try! <~?map["strings"]
        XCTAssert(optionalStrings! == self.strings)
        
        let stringInt: String = try! <~map["int"]
            .transformFromJson { (jsonValue: Int) in
                return "\(jsonValue)"
        }
        XCTAssert(stringInt == "272")
        
        let person: Person = try! <~map["person"]
        XCTAssert(person.firstName == "Joe")
        XCTAssert(person.lastName == "Fish")
        
        let optionalPerson: Person? = try! <~?map["person"]
        XCTAssert(optionalPerson!.firstName == "Joe")
        XCTAssert(optionalPerson!.lastName == "Fish")
        
        let people: [Person] = try! <~map["people"]
        let optionalPeople: [Person]? = try! <~?map["people"]
        
        for peopleArray in [people, optionalPeople!] {
            XCTAssert(peopleArray.count == 2)
            
            let joe = peopleArray[0]
            XCTAssert(joe.firstName == "Joe")
            XCTAssert(joe.lastName == "Fish")
            
            let jane = peopleArray[1]
            XCTAssert(jane.firstName == "Jane")
            XCTAssert(jane.lastName == "Bear")
        }
        
        let singleValueToArray: [Person] = try! <~map["person"]
        XCTAssert(singleValueToArray.count == 1)
        let joe = singleValueToArray.first!
        XCTAssert(joe.firstName == "Joe")
        XCTAssert(joe.lastName == "Fish")
        
        let emptyInt: Int? = try! <~?map["i_dont_exist"]
        XCTAssert(emptyInt == nil)
        let emptyStrings: [String]? = try! <~?map["i_dont_exist"]
        XCTAssert(emptyStrings == nil)
        let emptyPerson: Person? = try! <~?map["i_dont_exist"]
        XCTAssert(emptyPerson == nil)
        let emptyPersons: [Person]? = try! <~?map["i_dont_exist"]
        XCTAssert(emptyPersons == nil)
        
        map = nil
    }
    
    
    func testThatValueExistsButIsNotTheTypeExpectedNonOptional() {
        
        // Unexpected Type - BASIC
        do {
            /*
            Test that a value in json exists, but is not the type expected
            */
            let _: String = try <~map["int"]
            XCTFail("Incorrect type should throw error")
        } catch SequenceError.UnexpectedValue(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
        }
        
        // Unexpected Type - MAPPABLE
        do {
            let _: Person = try <~map["int"]
            XCTFail("Incorrect type should throw error")
        } catch SequenceError.UnexpectedValue(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
        }
        
        // Unexpected Type - MAPPABLE ARRAY
        do {
            let _: [Person] = try <~map["int"]
            XCTFail("Incorrect type should throw error")
        } catch SequenceError.UnexpectedValue(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
        }
        
        // Unexpected Type - TRANSFORMABLE
        do {
            // Transformer expects string, but is passed an int
            let _: String = try <~map["int"]
                .transformFromJson { (input: String) in
                    return "Hello: \(input)"
                }
            XCTFail("Incorrect type should throw error")
        } catch TransformationError.UnexpectedInputType(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(TransformationError.UnexpectedInputType)")
        }
    }
    
    // If a value exists, but is the wrong type, it should throw error
    func testThatValueExistsButIsNotTheTypeExpectedOptional() {
        
        // Unexpected Type - BASIC
        do {
            /*
            Test that a value in json exists, but is not the type expected
            */
            let _: String? = try <~?map["int"]
            XCTFail("Incorrect type should throw error")
        } catch SequenceError.UnexpectedValue(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
        }
        
        // Unexpected Type - MAPPABLE
        do {
            let _: Person? = try <~?map["int"]
            XCTFail("Incorrect type should throw error")
        } catch SequenceError.UnexpectedValue(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
        }
        
        // Unexpected Type - MAPPABLE ARRAY
        do {
            let _: [Person]? = try <~?map["int"]
            XCTFail("Incorrect type should throw error")
        } catch SequenceError.UnexpectedValue(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.UnexpectedValue)")
        }
        
        // Expected Non-Nil - TRANFORMABLE
        do {
            // Transformer expects string, but is passed an int
            let _: String? = try <~map["int"]
                .transformFromJson { (input: String?) in
                    return "Hello: \(input)"
            }
            XCTFail("Incorrect type should throw error")
        } catch TransformationError.UnexpectedInputType(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(TransformationError.UnexpectedInputType)")
        }
        
    }
    
    // Expected Something, Got Nothing
    func testThatValueDoesNotExistNonOptional() {
        // Expected Non-Nil - BASIC
        do {
            /*
            Test that a value in json exists, but is not the type expected
            */
            let _: String = try <~map["asdf"]
            XCTFail("nil value should throw error")
        } catch SequenceError.FoundNil(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.FoundNil)")
        }
        
        // Expected Non-Nil - MAPPABLE
        do {
            let _: Person = try <~map["asdf"]
            XCTFail("nil value should throw error")
        } catch SequenceError.FoundNil(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.FoundNil)")
        }
        
        // Expected Non-Nil - MAPPABLE ARRAY
        do {
            let _: [Person] = try <~map["asdf"]
            XCTFail("nil value should throw error")
        } catch SequenceError.FoundNil(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(SequenceError.FoundNil)")
        }
        
        // Expected Non-Nil - TRANFORMABLE
        do {
            // Transformer expects string, but is passed an int
            let _: String = try <~map["asdf"]
                .transformFromJson { (input: String) in
                    return "Hello: \(input)"
                }
            XCTFail("nil value should throw error")
        } catch TransformationError.UnexpectedInputType(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(TransformationError.UnexpectedInputType)")
        }
    }
    
    func testMapType() {
        do {
            map.type = .ToJson
            let _: String = try <~map["a"]
            XCTFail("Inproper map type should throw error")
        } catch MappingError.UnexpectedOperationType(_) {
            
        } catch {
            XCTFail("Incorrect Error: \(error) Expected: \(MappingError.UnexpectedOperationType)")
        }
        
    }

}
