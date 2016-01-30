//: Playground - noun: a place where people can play

import UIKit

/**
 If you are getting errors here, make sure you have built the frameworks. 
 
 Select `Genome-iOS` target
 Set Simulator Device
 Build w/ cmd + b
 
 Once that's done you should be good to go.
 
 You'll need to rebuild to access library changes here
 */
import Genome
import PureJsonSerializer

// MARK: Date Conversion

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
    
    class func birthdayStringWithDate(date: NSDate) throws -> String {
        let df = NSDateFormatter()
        df.dateFormat = "mm-d-yy"
        return df.stringFromDate(date)
    }
}

// MARK: Pet

enum PetType : String {
    case Dog = "dog"
    case Cat = "cat"
}

struct _Pet : MappableObject {
    let name: String
    let type: PetType
    let nickname: String
    
    init(map: Map) throws {
        name = try map.extract("name")
        nickname = try map.extract("nickname")
        type = try map["type"]
            .fromJson { PetType(rawValue: $0)! }
    }
    
    func sequence(map: Map) throws {
        try name ~> map["name"]
        try type ~> map["type"]
            .transformToJson { $0.rawValue }
        try nickname ~> map["nickname"]
    }
}

struct Pet : BasicMappable {
    var name: String!
    var type: PetType!
    var nickname: String?
    
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


let json_rover: Json = [
    "name" : "Rover",
    "nickname" : "RoRo",
    "type" : "dog"
]

let rover = try Pet(js: json_rover)
print(rover)

// MARK: Person

struct Person : MappableObject {
    let name: String
    let pet: Pet
    let birthday: NSDate
    
    let favoriteFood: String?

    init(map: Map) throws {
        pet = try map.extract("pet")
        name = try map.extract("name")
        favoriteFood = try map.extract("favorite_food")
        birthday = try map["birthday"]
            .fromJson(NSDate.dateWithBirthdayString)
    }
    
    mutating func sequence(map: Map) throws {
        try name ~> map["name"]
        try pet ~> map["pet"]
        try favoriteFood ~> map["favorite_food"]
        try birthday ~> map["birthday"]
            .transformToJson(NSDate.birthdayStringWithDate)
    }
}

let json_snowflake: Json = [
    "name" : "Snowflake",
    "type" : "cat"
]

let json_joe: Json = [
    "name" : "Joe",
    "birthday" : "12-15-84",
    "pet" : json_snowflake
]

let joe = try Person(js: json_joe)
print(joe)

// MARK: Creating A Custom Mappable

extension Int {
    static func fromString(string: String) -> Int {
        return Int(string)!
    }
}

extension String {
    static func fromInt(int: Int) -> String {
        return "\(int)"
    }
}

class CustomBase : MappableBase {
    required init() {}
    
    static func newInstance(json: Json, context: Context) throws -> Self {
        let map = Map(json: json, context: context)
        let new = self.init()
        try new.sequence(map)
        return new
    }
    
    func sequence(map: Map) throws {}
}

// MARK: Complex Example

class Book : MappableBase {
    var title: String = ""
    var releaseYear: Int = 0
    var id: String = ""
    
    required init() {}
    
    static func newInstance(json: Json, context: Context = EmptyJson) throws -> Self {
        let map = Map(json: json, context: context)
        return try newInstance(map)
    }
    
    static func newInstance(map: Map) throws -> Self {
        let id: String = try map.extract("id")
        let new = existingBookWithId(id) ?? self.init()
        try new.sequence(map)
        return new
    }
    
    func sequence(map: Map) throws {
        try title <~> map["title"]
        try id <~> map["id"]

        // String => Int
        try releaseYear <~> map["release_year"]
            .transformFromJson(Int.fromString)
            .transformToJson(String.fromInt)
    }
}

func existingBookWithId<T: Book>(id: String) -> T? {
    return nil
}

let json_book: Json = [
    "title" : "Title",
    "release_year" : "2009",
    "id" : "asd9fj20m"
]

let book = try! Book.newInstance(json_book)
print(book)

// MARK: Core Data Example

import CoreData

extension NSManagedObjectContext : Context {}

public class NSMappableManagedObject: NSManagedObject, MappableBase {
    public class var entityName: String {
        return "\(self)"
    }
    
    public func sequence(map: Map) throws {
        fatalError("Sequence must be overwritten")
    }
    
    public class func newInstance(json: Json, context: Context) throws -> Self {
        return try newInstance(json, context: context, type: self)
    }
    
    public class func newInstance<T: NSMappableManagedObject>(json: Json, context: Context, type: T.Type) throws -> T {
        let context = context as! NSManagedObjectContext
        let new = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as! T
        let map = Map(json: json, context: context)
        try new.sequence(map)
        return new
    }
}
