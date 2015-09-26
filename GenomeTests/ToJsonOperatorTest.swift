//
//  ToJsonOperatorTest.swift
//  Genome
//
//  Created by Logan Wright on 9/23/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
@testable import Genome

class ToJsonOperatorTest: XCTestCase {
    
    struct Business : StandardMappable {
        
        struct Employee : StandardMappable {
            let name: String
            
            init(map: Map) {
                name = try! <~map["name"]
            }
            
            mutating func sequence(map: Map) throws -> Void {
                try name ~> map["name"]
            }
        }
        
        let owner: Employee
        let ownerOptional: Employee?
        
        let name: String
        let foundedYear: Int
        let employees: [Employee]
        let employeesOptional: [Employee]?
        let locations: [String]
        
        let optionalNil: String?
        let optionalNotNil: String?
        
        init(map: Map) {
            name = try! <~map["name"]
            foundedYear = try! <~map["founded_in"]
            locations = try! <~map["locations"]
            employees = try! <~map["employees"]
            employeesOptional = try! <~?map["employees"]
            owner = try! <~map["owner"]
            ownerOptional = try! <~?map["owner"]
            
            optionalNil = nil
            optionalNotNil = "not nil"
        }
        
        mutating func sequence(map: Map) throws -> Void {
            try owner ~> map["owner"]
            try ownerOptional ~> map["ownerOptional"]
            try name ~> map["name"]
            try foundedYear ~> map["foundedYear"]
            try locations ~> map["locations"]
            try employees ~> map["employees"]
            try employeesOptional ~> map["employeesOptional"]
            try optionalNil ~> map["optionalNil"]
            try optionalNotNil ~> map["optionalNotNil"]
        }
    }

    
    let locations = [
        "123 Street",
        "456 Road"
    ]
    
    let employees = [
        [
            "name" : "Joe"
        ],
        [
            "name" : "Jane"
        ]
    ]
    
    let owner = [
        "name" : "Owner"
    ]
    
    lazy var BusinessJson: JSON = [
        "owner" : self.owner,
        "name" : "Good Business",
        "founded_in" : 1987,
        "locations" : self.locations,
        "employees" : self.employees
    ]
    
    lazy var goodBusiness: Business = try! Business.mappedInstance(self.BusinessJson)
    
    func test() {
        self.measureBlock {
            self._test()
        }
    }
    
    func _test() {
        let json = try! goodBusiness.jsonRepresentation()
        
        let locations = json["locations"] as! [String]
        XCTAssert(locations == self.locations)
        
        let employees = json["employees"] as! [[String : String]]
        XCTAssert(employees == self.employees)
        
        let employeesOptional = json["employeesOptional"] as! [[String : String]]
        XCTAssert(employeesOptional == self.employees)
        
        let owner = json["owner"] as! [String : String]
        XCTAssert(owner == self.owner)
        
        let ownerOptional = json["ownerOptional"] as! [String : String]
        XCTAssert(ownerOptional == self.owner)
        
        let name = json["name"] as! String
        XCTAssert(name == "Good Business")
        
        let optionalNil = json["optionalNil"]
        XCTAssert(optionalNil == nil)
        
        let optionalNotNil = json["optionalNotNil"]
        XCTAssert(optionalNotNil != nil)
    }
    
}
