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
    
    lazy var map: Map = Map(json: self.json)

    func test() {
        self.measureBlock {
            self._test()
        }
    }
    
    func _test() {
        let int: Int = try! <~map["int"]
        XCTAssert(int == 272)
        
        let optionalInt: Int? = try! <~map["int"]
        XCTAssert(optionalInt! == 272)
        
        let strings: [String] = try! <~map["strings"]
        XCTAssert(strings == self.strings)
        
        let optionalStrings: [String]? = try! <~map["strings"]
        XCTAssert(optionalStrings! == self.strings)
        
        let person: Person = try! <~map["person"]
        XCTAssert(person.firstName == "Joe")
        XCTAssert(person.lastName == "Fish")
        
        let optionalPerson: Person? = try! <~map["person"]
        XCTAssert(optionalPerson!.firstName == "Joe")
        XCTAssert(optionalPerson!.lastName == "Fish")
        
        let people: [Person] = try! <~map["people"]
        let optionalPeople: [Person]? = try! <~map["people"]
        
        for peopleArray in [people, optionalPeople!] {
            XCTAssert(peopleArray.count == 2)
            
            let joe = peopleArray[0]
            XCTAssert(joe.firstName == "Joe")
            XCTAssert(joe.lastName == "Fish")
            
            let jane = peopleArray[1]
            XCTAssert(jane.firstName == "Jane")
            XCTAssert(jane.lastName == "Bear")
        }
        
        
        let emptyInt: Int? = try? <~map["i_dont_exist"]
        XCTAssert(emptyInt == nil)
        let emptyStrings: [String]? = try? <~map["i_dont_exist"]
        XCTAssert(emptyStrings == nil)
        let emptyPerson: Person? = try? <~map["i_dont_exist"]
        XCTAssert(emptyPerson == nil)
        let emptyPersons: [Person]? = try? <~map["i_dont_exist"]
        XCTAssert(emptyPersons == nil)
    }
    
}
