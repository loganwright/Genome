//
//  GenomeTests.swift
//  GenomeTests
//
//  Created by Logan Wright on 6/27/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest

@testable import Genome

// MARK: Side Load Tests 

let SideLoadTestDna: Dna = [
    "people" : [
        [
            "name" : "A",
            "favorite_food_ids" : [1,2,3],
            "birthday" : "12-10-85"
        ],
        [
            "name" : "B",
            "favorite_food_ids" : [2,3,5],
            "birthday" : "12-23-87"
        ]
    ],
    "foods" : [
        [
            "id" : 1,
            "name" : "taco"
        ],
        [
            "id" : 2,
            "name" : "pizza"
        ],
        [
            "id" : 3,
            "name" : "potatoe"
        ],
        [
            "id" : 5,
            "name" : "cake"
        ],
    ]
]

struct Food : BasicMappable, Equatable {
    var id: Int = 0
    var name: String = ""
    var tastiness: Int?
 
    mutating func sequence(op: Map) throws -> Void {
        try id <~> op["id"]
        try name <~> op["name"]
        try tastiness <~> op["tastiness"]
    }
}

struct Person : BasicMappable {
    var name: String = ""
    var favoriteFoodIds: [Int] = []
    var birthday: NSDate?
    var favoriteFoods: [Food] = []
    
    mutating func sequence(map: Map) throws -> Void {
        try name <~> map["name"]
        
        try birthday <~> map["birthday"]
            .transformFromDna(NSDate.dateWithBirthdayString)
            .transformToDna(NSDate.birthdayStringWithDate)
        
        try favoriteFoodIds <~> map["favorite_food_ids"]
    }
    
    mutating func associateFavoriteFoods(foods: [Food]) {
        self.favoriteFoods = foods.filter { favoriteFoodIds.contains($0.id) }
    }
}

func ==(lhs: Food, rhs: Food) -> Bool {
    return lhs.id == rhs.id
}

extension Array where Element : Equatable {
    func containsAll(all: [Element]) -> Bool {
        for ob in all {
            if !self.contains(ob) {
                return false
            }
        }
        return true
    }
}

extension NSDate {
    class func dateWithBirthdayString(string: String?) -> NSDate? {
        let df = NSDateFormatter()
        df.dateFormat = "mm-d-yy"
        return df.dateFromString(string!)!
    }
    
    class func birthdayStringWithDate(date: NSDate?) -> String {
        let df = NSDateFormatter()
        df.dateFormat = "mm-d-yy"
        return df.stringFromDate(date!)
    }
}


extension Food : CustomStringConvertible {
    var description: String {
        return "\n\(self.dynamicType)" + "\nname: \(name)" + "\nid: \(id)\n"
    }
}

extension Person : CustomStringConvertible {
    var description: String {
        return "\n" + name + "\n" + "\(favoriteFoods)" + "\n" + "\(birthday)" + "\n"
    }
}

class GenomeSideLoadTests: XCTestCase {
    
    func testSideLoad() {
        let dnaArrayOfPeople = SideLoadTestDna["people"]!
        let single: Person! = try! Person(dna: dnaArrayOfPeople.arrayValue!.first!)
        XCTAssert(single != nil)
        
        let allFoods = try! [Food](js: SideLoadTestDna["foods"]!, context: SideLoadTestDna)
        XCTAssert(allFoods.count == 4)

        var peeps: [Person] = try! [Person](js: dnaArrayOfPeople, context: SideLoadTestDna)
        peeps = peeps.map { (var person) -> Person in person.associateFavoriteFoods(allFoods); return person }
        XCTAssert(peeps.count == 2)
        
        let a = peeps.first!
        let aBirth = NSDate.dateWithBirthdayString("12-10-85")
        XCTAssert(a.name == "A")
        XCTAssert(a.birthday == aBirth)
        XCTAssert(a.favoriteFoods.count == 3)
        XCTAssert(allFoods.containsAll(a.favoriteFoods))
        
        // Assert Dna
        
        let dna = try! peeps.first!.dnaRepresentation()
        print("Write dna tests \(dna)")
        let peepsDna = try! peeps.dnaRepresentation()
        print("Peeps: \(peepsDna)")
        
        let m = Map()
        try! peeps <~> m
        print("mjs: \(m.toDna)")
    }
    
}

// MARK: Standard Operator Tests

let Ints: Dna = [1,2,3,4,5]
let StandardOperatorDna: Dna = [
    "ints" : Ints
]

class StandardOperatorTests: XCTestCase {
    
    func testSideLoad() {
        let map = Map(dna: StandardOperatorDna)
        var ints: [Int] = []
        try! ints <~> map["ints"]
        XCTAssert(ints == Ints.arrayValue!.flatMap { $0.intValue })
        
        var intsOptional: [Int]?
        try! intsOptional <~> map["ints"]
        XCTAssert(intsOptional! == Ints.arrayValue!.flatMap { $0.intValue })
    }
    
}
