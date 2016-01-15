//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: ToJson

public func ~> <T : JsonConvertibleType>(reference: T!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try map.setToLastKey(reference)
    case .FromJson:
        break
    }
}

public func ~> <T: JsonConvertibleType>(reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try map.setToLastKey(reference)
    case .FromJson:
        break
    }
}

public func ~> <T: JsonConvertibleType>(reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try map.setToLastKey(reference)
    case .FromJson:
        break
    }
}

public func ~> <T: JsonConvertibleType>(reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try map.setToLastKey(reference)
    case .FromJson:
        break
    }
}

public func ~> <T: JsonConvertibleType>(reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try map.setToLastKey(reference)
    case .FromJson:
        break
    }
}

public func ~> <T : JsonConvertibleType>(reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try map.setToLastKey(reference)
    case .FromJson:
        break
    }
}

// MARK: FromJson

infix operator <~ {}

public func <~ <T: JsonConvertibleType>(inout reference: T, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: T!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: T?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: [T], map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: [T]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: [[T]], map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: [[T]]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: [String : T], map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: [String : T]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: [String : [T]], map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: [String : [T]]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: Set<T>, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

public func <~ <T: JsonConvertibleType>(inout reference: Set<T>?, map: Map) throws {
    switch map.type {
    case .ToJson:
        break
    case .FromJson:
        reference = try <~map
    }
}

// MARK: Two Way Operator

infix operator <~> {}

public func <~> <T: JsonConvertibleType>(inout reference: T, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: T!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: T?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: [T], map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: [T]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: [[T]], map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: [[T]]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: [String : T], map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: [String : T]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: [String : [T]], map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: [String : [T]]?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: Set<T>, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}

public func <~> <T: JsonConvertibleType>(inout reference: Set<T>?, map: Map) throws {
    switch map.type {
    case .ToJson:
        try reference ~> map
    case .FromJson:
        try reference <~ map
    }
}
