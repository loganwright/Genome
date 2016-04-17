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

let SideLoadTestNode: Node = [
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
 
    mutating func sequence(_ op: Map) throws -> Void {
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
    
    mutating func sequence(_ map: Map) throws -> Void {
        try name <~> map["name"]
        
        try birthday <~> map["birthday"]
            .transformFromNode(transformer: NSDate.dateWithBirthdayString)
            .transformToNode(transformer: NSDate.birthdayStringWithDate)
        
        try favoriteFoodIds <~> map["favorite_food_ids"]
    }
    
    mutating func associateFavoriteFoods(foods: [Food]) {
        self.favoriteFoods = foods.filter { favoriteFoodIds.contains($0.id) }
        print("\(name) has favorite foods: \(self.favoriteFoods) ids: \(favoriteFoodIds) input: \(foods)")
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
        #if swift(>=3.0)
        return df.date(from: string!)!
        #else
        return df.dateFromString(string!)!
        #endif
    }
    
    class func birthdayStringWithDate(date: NSDate?) -> String {
        let df = NSDateFormatter()
        df.dateFormat = "mm-d-yy"
        #if swift(>=3.0)
        return df.string(from: date!)
        #else
        return df.stringFromDate(date!)
        #endif
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

    func testFood() throws {
        let node: Node = [
            "id" : 1,
            "name" : "taco"
        ]
        let food = try Food(node: node)
        XCTAssert(food.id == 1)
        XCTAssert(food.name == "taco")
    }

    func testSideLoad() {
        let nodeArrayOfPeople = SideLoadTestNode["people"]!
        let single: Person! = try! Person(node: nodeArrayOfPeople.arrayValue!.first!)
        XCTAssert(single != nil)

        let foodsJs = SideLoadTestNode["foods"]!
        print("FoodsJs: \(foodsJs)")
        let allFoods = try! [Food].init(node: foodsJs, context: SideLoadTestNode)
        XCTAssert(allFoods.count == 4)

        var peeps: [Person] = try! [Person](node: nodeArrayOfPeople, context: SideLoadTestNode)
        peeps = peeps.map { (person) -> Person in
            var mutable = person
            mutable.associateFavoriteFoods(foods: allFoods);
            return mutable
        }
        XCTAssert(peeps.count == 2)
        
        let a = peeps.first!
        let aBirth = NSDate.dateWithBirthdayString(string: "12-10-85")
        XCTAssert(a.name == "A")
        XCTAssert(a.birthday == aBirth)
        XCTAssert(a.favoriteFoods.count == 3)
        XCTAssert(allFoods.containsAll(all: a.favoriteFoods))
        
        // Assert Node
        
        let node = try! peeps.first!.makeNode()
        print("Write node tests \(node)")
        let peepsNode = try! peeps.makeNode()
        print("Peeps: \(peepsNode)")
        
        let m = Map()
        try! peeps <~> m
        print("mnode: \(m.node)")
    }

}

// MARK: Standard Operator Tests

let Ints: Node = [1,2,3,4,5]
let StandardOperatorNode: Node = [
    "ints" : Ints
]

class StandardOperatorTests: XCTestCase {
    
//    func testSideLoad() {
//        let map = Map(node: StandardOperatorNode)
//        var ints: [Int] = []
//        try! ints <~> map["ints"]
//        XCTAssert(ints == Ints.arrayValue!.flatMap { $0.intValue })
//        
//        var intsOptional: [Int]?
//        try! intsOptional <~> map["ints"]
//        XCTAssert(intsOptional! == Ints.arrayValue!.flatMap { $0.intValue })
//    }
    
}
