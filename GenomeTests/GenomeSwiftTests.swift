//
//  GenomeTests.swift
//  GenomeTests
//
//  Created by Logan Wright on 6/27/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
import Genome

// MARK: Side Load Tests 

let SideLoadTestJson = [
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
            .transformFromJson(NSDate.dateWithBirthdayString)
            .transformToJson(NSDate.birthdayStringWithDate)
        
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
    class func dateWithBirthdayString(string: String) -> NSDate? {
        let df = NSDateFormatter()
        df.dateFormat = "mm-d-yy"
        return df.dateFromString(string)!
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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSideLoad() {
        let jsonArrayOfPeople = SideLoadTestJson["people"]!
        let single: Person! = try! Person.mappedInstance(jsonArrayOfPeople.first as! JSON)
//        let single: Person! = Sequence(jsonArrayOfPeople.first)
        XCTAssert(single != nil)
        
        let allFoods = try! [Food].mappedInstance(SideLoadTestJson["foods"] as! [JSON], context: SideLoadTestJson)
//        let allFoods: [Food] = Sequence(SideLoadTestJson["foods"], inContext: SideLoadTestJson)
        XCTAssert(allFoods.count == 4)

        var peeps: [Person] = try! [Person].mappedInstance(jsonArrayOfPeople as! [JSON], context: SideLoadTestJson)
//        var peeps: [Person] = Sequence(jsonArrayOfPeople, inContext: SideLoadTestJson)
        peeps = peeps.map { (var person) -> Person in person.associateFavoriteFoods(allFoods); return person }
        XCTAssert(peeps.count == 2)
        
        let a = peeps.first!
        let aBirth = NSDate.dateWithBirthdayString("12-10-85")
        XCTAssert(a.name == "A")
        XCTAssert(a.birthday == aBirth)
        XCTAssert(a.favoriteFoods.count == 3)
        XCTAssert(allFoods.containsAll(a.favoriteFoods))
        
        // Assert Json
        
        let json = try! peeps.first!.jsonRepresentation()
        print("Todo: Write json tests \(json)")
        let peepsJson = peeps.map { try! $0.favoriteFoods.jsonRepresentation() }
        print("Peeps: \(peepsJson)")
        
        let m = Map()
        m.type = .ToJson
        try! peeps <~> m
        print("mjs: \(m.toJson)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}

// MARK: Standard Operator Tests

let Ints = [1,2,3,4,5]
let StandardOperatorJson = [
    "ints" : Ints
]

class StandardOperatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSideLoad() {
        let map = Map(json: StandardOperatorJson)
        var ints: [Int] = []
        try! ints <~> map["ints"]
        XCTAssert(ints == Ints)
        print("Ints: \(ints)")
        
        var intsOptional: [Int]?
        try! intsOptional <~> map["ints"]
        XCTAssert(intsOptional! == Ints)
        print("IntsOptional: \(intsOptional)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}


let ComplexOperatorJson: JSON = [
    "peeps" : [
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
    ]
]

class ComplexOperatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSideLoad() {
        let peeeeps: [Person]? = try! [Person].mappedInstance(SideLoadTestJson["people"] as! [JSON])
//        let peeeeps: [Person]? = Sequence(SideLoadTestJson["people"] as! [JSON])
        print(peeeeps)
        let map = Map(json: ComplexOperatorJson)
        var peeps: [Person]? = []
        try! peeps <~> map["peeps"]
//        XCTAssert(peeps == Ints)
        print("Peeps: \(peeps)")
        
        var peepsOptional: [Person]?
        try! peepsOptional <~> map["peeps"]
//        XCTAssert(peepsOptional! == Ints)
        print("PeepsOptional: \(peepsOptional)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
