//
//  Operators.swift
//  Genome
//
//  Created by Logan Wright on 6/30/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

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

public func ~> <T: MappableObject>(reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try map.setToLastKey(reference)
    case .FromJson:
        break
    }
}

public func ~> <T: MappableObject>(reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try map.setToLastKey(reference)
    case .FromJson:
        break
    }
}

public func ~> <T: MappableObject>(reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try map.setToLastKey(reference)
    case .FromJson:
        break
    }
}

public func ~> <T : MappableObject>(reference: Set<T>!, map: Map) throws {
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
        reference = try <~map
    }
}

public func <~ <T>(inout reference: T!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T>(inout reference: T?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T: MappableObject>(inout reference: T, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: MappableObject>(inout reference: T!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T: MappableObject>(inout reference: T?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T: MappableObject>(inout reference: [T], map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: MappableObject>(inout reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T: MappableObject>(inout reference: [T]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T: MappableObject>(inout reference: [[T]], map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: MappableObject>(inout reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T: MappableObject>(inout reference: [[T]]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T: MappableObject>(inout reference: [String : T], map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: MappableObject>(inout reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T: MappableObject>(inout reference: [String : T]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T: MappableObject>(inout reference: [String : [T]], map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: MappableObject>(inout reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T: MappableObject>(inout reference: [String : [T]]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T: MappableObject>(inout reference: Set<T>, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: MappableObject>(inout reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
    }
}

public func <~ <T: MappableObject>(inout reference: Set<T>?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~?map
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

public func <~> <T: MappableObject>(inout reference: [[T]], map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: [[T]]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: [String : T], map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: [String : T]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: [String : [T]], map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: [String : [T]]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: Set<T>, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: MappableObject>(inout reference: Set<T>?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}
