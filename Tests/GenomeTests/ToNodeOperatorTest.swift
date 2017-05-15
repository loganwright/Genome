//
//  ToNodeOperatorTest.swift
//  Genome
//
//  Created by Logan Wright on 9/23/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest

@testable import Genome

class ToNodeOperatorTest: XCTestCase {
    static let allTests = [
        ("testMapping", testMapping)
    ]

    struct Employee: BasicMappable, Hashable {
        
        var name: String = ""
        
        mutating func sequence(_ map: Map) throws -> Void {
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
        
        init(map: Map) throws {
            name = try map.extract("name")
            foundedYear = try map.extract("founded_in")
            
            locations = try map.extract("locations")
            locationsOptional = try map.extract("locations")
            
            let ownerrr: Employee = try map.extract("owner")
            print("Ownerer: \(ownerrr)")
            owner = try map.extract("owner")
            ownerOptional = try map.extract("owner")
            
            employees = try map.extract("employees")
            employeesOptional = try map.extract("employees")
            
            employeesArray = try map.extract("employeesArray")
            employeesOptionalArray = try map.extract("employeesArray")
            
            employeesDictionary = try map.extract("employeesDictionary")
            employeesOptionalDictionary = try map.extract("employeesDictionary")
            
            employeesDictionaryArray = try map.extract("employeesDictionaryArray")
            employeesOptionalDictionaryArray = try map.extract("employeesDictionaryArray")
            
            employeesSet = try map.extract("employees")
            employeesOptionalSet = try map.extract("employees")
        }
        
        func sequence(_ map: Map) throws -> Void {
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
    
    let locations: Node = [
        "123 Street",
        "456 Road"
    ]
    
    let employees: Node = [
        ["name" : "Joe"],
        ["name" : "Jane"],
        ["name" : "Joe"],
        ["name" : "Justin"]
    ]
    
    let employeesArray: Node = [
        [["name" : "Joe"], ["name" : "Jane"]],
        [["name" : "Joe"], ["name" : "Justin"]]
    ]
    
    let employeesDictionary: Node = [
        "0" : ["name" : "Joe"],
        "1" : ["name" : "Jane"]
    ]
    
    let employeesDictionaryArray: Node = [
        "0" : [["name" : "Joe"], ["name" : "Phil"]],
        "1" : [["name" : "Jane"]]
    ]
    
    let employeesSet: Node = [
        ["name" : "Joe"],
        ["name" : "Jane"],
        ["name" : "Justin"]
    ]
    
    let owner: Node = [
        "name" : "Owner"
    ]
    
    lazy var businessNode: Node = [
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
    
    func testMapping() throws {
        let goodBusiness = try Business(node: businessNode)
        let node = try goodBusiness.makeNode()
        // Basic type
        let name = try node["name"].unwrap().string.unwrap()
        XCTAssertEqual(name, "Good Business", "name is \(name) expected: Good Business")
        let foundedYear = try node["foundedYear"].unwrap().int
        XCTAssertEqual(foundedYear, 1987)
        
        // Basic type array
        let locations = try node["locations"].unwrap()
        XCTAssertEqual(locations, self.locations, "locations is \(locations) expected: \(self.locations)")
        let locationsOptional = node["locationsOptional"]
        XCTAssertEqual(locationsOptional, self.locations)
        
        // Mappable
        let owner = try node["owner"].unwrap()
        XCTAssertEqual(owner, self.owner, "owner is \(owner) expected: \(self.owner)")
        let ownerOptional = node["ownerOptional"]
        XCTAssertEqual(ownerOptional, self.owner)
        
        // Mappable array
        let employees = try node["employees"].unwrap()
        XCTAssertEqual(employees, self.employees, "employees is \(employees) expected: \(self.employees)")
        let employeesOptional = node["employeesOptional"]
        XCTAssertEqual(employeesOptional, self.employees, "employeesOptional is \(employees) expected: \(self.employees)")
        
        // Mappable array of arrays
        let employeesArray = try node["employeesArray"].unwrap()
        XCTAssertEqual(employeesArray[0], self.employeesArray[0])
        XCTAssertEqual(employeesArray[1], self.employeesArray[1])
        let employeesOptionalArray = node["employeesOptionalArray"]
        XCTAssertEqual(employeesOptionalArray?[0], self.employeesArray[0])
        XCTAssertEqual(employeesOptionalArray?[1], self.employeesArray[1])
        
        // Mappable dictionary
        let employeesDictionary = try node["employeesDictionary"].unwrap()
        XCTAssertEqual(employeesDictionary["0"], self.employeesDictionary["0"])
        XCTAssertEqual(employeesDictionary["1"], self.employeesDictionary["1"])
        let employeesOptionalDictionary = node["employeesOptionalDictionary"]
        XCTAssertEqual(employeesOptionalDictionary?["0"], self.employeesDictionary["0"])
        XCTAssertEqual(employeesOptionalDictionary?["1"], self.employeesDictionary["1"])
        
        // Mappable dictionary array
        let employeesDictionaryArray = try node["employeesDictionaryArray"].unwrap()
        XCTAssertEqual(employeesDictionaryArray["0"], self.employeesDictionaryArray["0"])
        XCTAssertEqual(employeesDictionaryArray["1"], self.employeesDictionaryArray["1"])
        let employeesOptionalDictionaryArray = node["employeesOptionalDictionaryArray"]
        XCTAssertEqual(employeesOptionalDictionaryArray?["0"], self.employeesDictionaryArray["0"])
        XCTAssertEqual(employeesOptionalDictionaryArray?["1"], self.employeesDictionaryArray["1"])
        
        // Mappable set
        // Temporarily commented out on linux because it's reordering array
        #if Xcode
        let employeesSet = try node["employeesSet"].unwrap()
        XCTAssertEqual(employeesSet, self.employeesSet)
        let employeesOptionalSet = node["employeesOptionalSet"]
        XCTAssertEqual(employeesOptionalSet, self.employeesSet)
        #endif

        // Nil
        let optionalNil = node["optionalNil"]
        XCTAssertNil(optionalNil)
        let optionalNotNil = node["optionalNotNil"]
        XCTAssertNotNil(optionalNotNil)
    }
    
}

// MARK: Operators

func ==(lhs: ToNodeOperatorTest.Employee, rhs: ToNodeOperatorTest.Employee) -> Bool {
    return lhs.name == rhs.name
}
