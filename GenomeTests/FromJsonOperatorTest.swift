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
    
    struct Person : BasicMappable {
        var name = ""
        
        mutating func sequence(map: Map) throws -> Void {
            try name <~ map["name"]
        }
    }
    
    let numbers = [0, 1, 2]
    let joe = ["name" : "Joe"]
    let jane = ["name" : "Jane"]
    
    lazy var json: JSON = [
        "string" : "pass",
        "numbers" : self.numbers,
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
        var string = ""
        try! string <~ map["string"]
        XCTAssert(string == "pass")
        
        var optionalString: String?
        try! optionalString <~ map["string"]
        XCTAssert(optionalString! == "pass")
        
        var numbers: [Int] = []
        try! numbers <~ map["numbers"]
        XCTAssert(numbers == self.numbers)
        
        var optionalNumbers: [Int]?
        try! optionalNumbers <~ map["numbers"]
        XCTAssert(optionalNumbers! == self.numbers)
        
        var person: Person = Person()
        try! person <~ map["person"]
        XCTAssert(person.name == "Joe")
        
        var optionalPerson: Person?
        try! optionalPerson <~ map["person"]
        XCTAssert(optionalPerson!.name == "Joe")
        
        var people: [Person] = []
        try! people <~ map["people"]
        
        var optionalPeople: [Person]?
        try! optionalPeople <~ map["people"]
        
        for peopleArray in [people, optionalPeople!] {
            XCTAssert(peopleArray.count == 2)
            
            let joe = peopleArray[0]
            XCTAssert(joe.name == "Joe")
            
            let jane = peopleArray[1]
            XCTAssert(jane.name == "Jane")
        }
        
        var emptyInt: Int?
        try! emptyInt <~ map["i_dont_exist"]
        XCTAssert(emptyInt == nil)
        var emptyStrings: [String]?
        try! emptyStrings <~ map["i_dont_exist"]
        XCTAssert(emptyStrings == nil)
        var emptyPerson: Person?
        try! emptyPerson <~ map["i_dont_exist"]
        XCTAssert(emptyPerson == nil)
        var emptyPersons: [Person]?
        try! emptyPersons <~ map["i_dont_exist"]
        XCTAssert(emptyPersons == nil)
    }
    
}
