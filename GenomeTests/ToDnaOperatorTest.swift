//
//  ToDnaOperatorTest.swift
//  Genome
//
//  Created by Logan Wright on 9/23/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest

@testable import Genome

class ToDnaOperatorTest: XCTestCase {
    
    struct Employee: BasicMappable, Hashable {
        
        var name: String = ""
        
        mutating func sequence(map: Map) throws -> Void {
            try name <~> map["name"]
        }
        
        var hashValue: Int {
            return name.hashValue
        }
        
    }
    
    struct Business: MappableObject {
        
        let name: String
        let foundedYear: Int
        
        let locations: [String]
        let locationsOptional: [String]?
        
        let owner: Employee
        let ownerOptional: Employee?
        
        let employees: [Employee]
        let employeesOptional: [Employee]?
        
        let employeesArray: [[Employee]]
        let employeesOptionalArray: [[Employee]]?
        
        let employeesDictionary: [String : Employee]
        let employeesOptionalDictionary: [String : Employee]?
        
        let employeesDictionaryArray: [String : [Employee]]
        let employeesOptionalDictionaryArray: [String : [Employee]]?
        
        let employeesSet: Set<Employee>
        let employeesOptionalSet: Set<Employee>?
        
        var optionalNil: String?
        var optionalNotNil: String? = "not nil"
        
        init(map: Map) {
            name = try! map.extract("name")
            foundedYear = try! map.extract("founded_in")
            
            locations = try! map.extract("locations")
            locationsOptional = try! map.extract("locations")
            
            let ownerrr: Employee = try! map.extract("owner")
            print("Ownerer: \(ownerrr)")
            owner = try! map.extract("owner")
            ownerOptional = try! map.extract("owner")
            
            employees = try! map.extract("employees")
            employeesOptional = try! map.extract("employees")
            
            employeesArray = try! map.extract("employeesArray")
            employeesOptionalArray = try! map.extract("employeesArray")
            
            employeesDictionary = try! map.extract("employeesDictionary")
            employeesOptionalDictionary = try! map.extract("employeesDictionary")
            
            employeesDictionaryArray = try! map.extract("employeesDictionaryArray")
            employeesOptionalDictionaryArray = try! map.extract("employeesDictionaryArray")
            
            employeesSet = try! map.extract("employees")
            employeesOptionalSet = try! map.extract("employees")
        }
        
        func sequence(map: Map) throws -> Void {
            try name ~> map["name"]
            try foundedYear ~> map["foundedYear"]
            
            try locations ~> map["locations"]
            try locationsOptional ~> map["locationsOptional"]
            
            try owner ~> map["owner"]
            try ownerOptional ~> map["ownerOptional"]
            
            try employees ~> map["employees"]
            try employeesOptional ~> map["employeesOptional"]
            
            try employeesArray ~> map["employeesArray"]
            try employeesOptionalArray ~> map["employeesOptionalArray"]
            
            try employeesDictionary ~> map["employeesDictionary"]
            try employeesOptionalDictionary ~> map["employeesOptionalDictionary"]
            
            try employeesDictionaryArray ~> map["employeesDictionaryArray"]
            try employeesOptionalDictionaryArray ~> map["employeesOptionalDictionaryArray"]
            
            try employeesSet ~> map["employeesSet"]
            try employeesOptionalSet ~> map["employeesOptionalSet"]
            
            try optionalNil ~> map["optionalNil"]
            try optionalNotNil ~> map["optionalNotNil"]
        }
    }
    
    let locations: Dna = [
        "123 Street",
        "456 Road"
    ]
    
    let employees: Dna = [
        ["name" : "Joe"],
        ["name" : "Jane"],
        ["name" : "Joe"],
        ["name" : "Justin"]
    ]
    
    let employeesArray: Dna = [
        [["name" : "Joe"], ["name" : "Jane"]],
        [["name" : "Joe"], ["name" : "Justin"]]
    ]
    
    let employeesDictionary: Dna = [
        "0" : ["name" : "Joe"],
        "1" : ["name" : "Jane"]
    ]
    
    let employeesDictionaryArray: Dna = [
        "0" : [["name" : "Joe"], ["name" : "Phil"]],
        "1" : [["name" : "Jane"]]
    ]
    
    let employeesSet: Dna = [
        ["name" : "Joe"],
        ["name" : "Jane"],
        ["name" : "Justin"]
    ]
    
    let owner: Dna = [
        "name" : "Owner"
    ]
    
    lazy var businessDna: Dna = [
        "owner" : self.owner,
        "name" : "Good Business",
        "founded_in" : 1987,
        "locations" : self.locations,
        "employees" : self.employees,
        "employeesArray" : self.employeesArray,
        "employeesDictionary" : self.employeesDictionary,
        "employeesDictionaryArray" : self.employeesDictionaryArray,
        "employeesSet" : self.employeesSet
    ]
    
    lazy var goodBusiness: Business = try! Business(dna: self.businessDna)
    
    func test() {
        let dna = try! goodBusiness.dnaRepresentation()
        
        // Basic type
        let name = dna["name"]!.stringValue!
        XCTAssert(name == "Good Business")
        let foundedYear = dna["foundedYear"]!.intValue
        XCTAssert(foundedYear == 1987)
        
        // Basic type array
        let locations = dna["locations"]!
        XCTAssert(locations == self.locations)
        let locationsOptional = dna["locationsOptional"]
        XCTAssert(locationsOptional == self.locations)
        
        // Mappable
        let owner = dna["owner"]!
        XCTAssert(owner == self.owner)
        let ownerOptional = dna["ownerOptional"]
        XCTAssert(ownerOptional == self.owner)
        
        // Mappable array
        let employees = dna["employees"]!
        XCTAssert(employees == self.employees)
        let employeesOptional = dna["employeesOptional"]
        XCTAssert(employeesOptional == self.employees)
        
        // Mappable array of arrays
        let employeesArray = dna["employeesArray"]!
        XCTAssert(employeesArray[0] == self.employeesArray[0])
        XCTAssert(employeesArray[1] == self.employeesArray[1])
        let employeesOptionalArray = dna["employeesOptionalArray"]
        XCTAssert(employeesOptionalArray![0]! == self.employeesArray[0])
        XCTAssert(employeesOptionalArray![1]! == self.employeesArray[1])
        
        // Mappable dictionary
        let employeesDictionary = dna["employeesDictionary"]!
        XCTAssert(employeesDictionary["0"]! == self.employeesDictionary["0"]!)
        XCTAssert(employeesDictionary["1"]! == self.employeesDictionary["1"]!)
        let employeesOptionalDictionary = dna["employeesOptionalDictionary"]
        XCTAssert(employeesOptionalDictionary!["0"]! == self.employeesDictionary["0"]!)
        XCTAssert(employeesOptionalDictionary!["1"]! == self.employeesDictionary["1"]!)
        
        // Mappable dictionary array
        let employeesDictionaryArray = dna["employeesDictionaryArray"]!
        XCTAssert(employeesDictionaryArray["0"]! == self.employeesDictionaryArray["0"]!)
        XCTAssert(employeesDictionaryArray["1"]! == self.employeesDictionaryArray["1"]!)
        let employeesOptionalDictionaryArray = dna["employeesOptionalDictionaryArray"]
        XCTAssert(employeesOptionalDictionaryArray!["0"]! == self.employeesDictionaryArray["0"]!)
        XCTAssert(employeesOptionalDictionaryArray!["1"]! == self.employeesDictionaryArray["1"]!)
        
        // Mappable set
        let employeesSet = dna["employeesSet"]!
        XCTAssert(employeesSet == self.employeesSet)
        let employeesOptionalSet = dna["employeesOptionalSet"]
        XCTAssert(employeesOptionalSet == self.employeesSet)
        
        // Nil
        let optionalNil = dna["optionalNil"]
        XCTAssert(optionalNil == nil)
        let optionalNotNil = dna["optionalNotNil"]
        XCTAssert(optionalNotNil != nil)
    }
    
}

// MARK: Operators

func ==(lhs: ToDnaOperatorTest.Employee, rhs: ToDnaOperatorTest.Employee) -> Bool {
    return lhs.name == rhs.name
}
