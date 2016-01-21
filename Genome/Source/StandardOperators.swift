//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: ToDna

public func ~> <T : DnaConvertibleType>(reference: T!, map: Map) throws {
    switch map.type {
    case .ToDna:
        try map.setToLastKey(reference)
    case .FromDna:
        break
    }
}

public func ~> <T: DnaConvertibleType>(reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToDna:
        try map.setToLastKey(reference)
    case .FromDna:
        break
    }
}

public func ~> <T: DnaConvertibleType>(reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .ToDna:
        try map.setToLastKey(reference)
    case .FromDna:
        break
    }
}

public func ~> <T: DnaConvertibleType>(reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .ToDna:
        try map.setToLastKey(reference)
    case .FromDna:
        break
    }
}

public func ~> <T: DnaConvertibleType>(reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .ToDna:
        try map.setToLastKey(reference)
    case .FromDna:
        break
    }
}

public func ~> <T : DnaConvertibleType>(reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .ToDna:
        try map.setToLastKey(reference)
    case .FromDna:
        break
    }
}

// MARK: FromDna

infix operator <~ {}

public func <~ <T: DnaConvertibleType>(inout reference: T, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: T!, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: T?, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: [T], map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: [T]?, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: [[T]], map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: [[T]]?, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: [String : T], map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: [String : T]?, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: [String : [T]], map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: [String : [T]]?, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: Set<T>, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

public func <~ <T: DnaConvertibleType>(inout reference: Set<T>?, map: Map) throws {
    switch map.type {
    case .ToDna:
        break
    case .FromDna:
        reference = try <~map
    }
}

// MARK: Two Way Operator

infix operator <~> {}

public func <~> <T: DnaConvertibleType>(inout reference: T, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: T!, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: T?, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: [T], map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: [T]?, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: [[T]], map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: [[T]]?, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: [String : T], map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: [String : T]?, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: [String : [T]], map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: [String : [T]]?, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: Set<T>, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}

public func <~> <T: DnaConvertibleType>(inout reference: Set<T>?, map: Map) throws {
    switch map.type {
    case .ToDna:
        try reference ~> map
    case .FromDna:
        try reference <~ map
    }
}
