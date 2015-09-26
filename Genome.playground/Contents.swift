//: Playground - noun: a place where people can play

import UIKit

let json_rover: JSON = [
    "name" : "Rover",
    "nickname" : "RoRo",
    "type" : "dog"
]

let json_jane: JSON = [
    "name" : "jane",
    "birthday" : "12-10-85",
    "pet" : json_rover
]

let json_snowflake: JSON = [
    "name" : "Snowflake",
    "type" : "cat"
]

let json_joe: JSON = [
    "name" : "Joe",
    "birthday" : "12-15-84",
    "pet" : json_snowflake
]

enum DateTransformationError : ErrorType {
    case UnableToConvertString
}

extension NSDate {
    class func dateWithBirthdayString(string: String) throws -> NSDate {
        let df = NSDateFormatter()
        df.dateFormat = "mm-d-yy"
        if let date = df.dateFromString(string) {
            return date
        } else {
            throw DateTransformationError.UnableToConvertString
        }
    }
    
    class func birthdayStringWithDate(date: NSDate?) -> String? {
        guard let date = date else { return nil }
        let df = NSDateFormatter()
        df.dateFormat = "mm-d-yy"
        return df.stringFromDate(date)
    }
}

enum PetType : String {
    case Dog = "dog"
    case Cat = "cat"
}

struct Pet {
    var name = ""
    var type: PetType!
    var nickname: String?
}

struct Person {
    let name: String
    let pet: Pet
    let birthday: NSDate
    
    let favoriteFood: String?
}

extension Pet : BasicMappable {
    mutating func sequence(map: Map) throws {
        try name <~> map["name"]
        try nickname <~> map["nickname"]
        try type <~> map["type"]
            .transformFromJson {
                return PetType(rawValue: $0)
            }
            .transformToJson {
                return $0.rawValue
            }
    }
}

extension Person : StandardMappable {
    init(map: Map) throws {
        try pet = <~map["pet"]
        try name = <~map["name"]
        try birthday = <~map["birthday"]
            .transformFromJson(NSDate.dateWithBirthdayString)
        try favoriteFood = <~?map["favorite_food"]
    }
    
    mutating func sequence(map: Map) throws {
        try name ~> map["name"]
        try pet ~> map["pet"]
        try birthday ~> map["birthday"]
            .transformToJson(NSDate.birthdayStringWithDate)
        try favoriteFood ~> map["favorite_food"]
    }
}

do {
    let rover = try Pet.mappedInstance(json_rover)
    print(rover)
} catch {
    print(error)
}

let joe = try Person.mappedInstance(json_joe)
joe.name
joe.favoriteFood
joe.pet.type
joe.pet.name
joe.birthday




