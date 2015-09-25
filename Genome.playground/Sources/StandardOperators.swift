//
//  Operators.swift
//  Genome
//
//  Created by Logan Wright on 6/30/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import Foundation

enum SequenceError : ErrorType {
    case FoundNil(String)
    case UnexpectedValue(String)
}

// MARK: ToJson

public func ~> <T>(reference: T!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try map.setToLastKey(reference)
    case .FromJson:
        break
    }
}

public func ~> <T : MappableObject>(reference: T!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try map.setToLastKey(reference)
    case .FromJson:
        break
    }
}

public func ~> <T: MappableObject>(reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try map.setToLastKey(reference)
    case .FromJson:
        break
    }
}

// MARK: FromJson

infix operator <~ {}

public func <~ <T>(inout reference: T, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try *map
    }
}

public func <~ <T>(inout reference: T!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try *?map
    }
}

public func <~ <T>(inout reference: T?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try *?map
    }
}

public func <~ <T: MappableObject>(inout reference: T, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try *map
    }
}

public func <~ <T: MappableObject>(inout reference: T!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try *?map
    }
}

public func <~ <T: MappableObject>(inout reference: T?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try *?map
    }
}

public func <~ <T: MappableObject>(inout reference: [T], map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try *map
    }
}

public func <~ <T: MappableObject>(inout reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try *?map
    }
}

public func <~ <T: MappableObject>(inout reference: [T]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try *?map
    }
}

// MARK: Two Way Operator

infix operator <~> {}

public func <~> <T>(inout reference: T, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T>(inout reference: T!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T>(inout reference: T?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

// MARK: Mappable

public func <~> <T: MappableObject>(inout reference: T, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: T!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: T?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: [T], map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: [T]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}
