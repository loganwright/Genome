//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: ToNode

public func ~> <T : NodeConvertibleType>(reference: T!, map: Map) throws {
    switch map.type {
    case .ToNode:
        try map.setToLastKey(reference)
    case .FromNode:
        break
    }
}

public func ~> <T: NodeConvertibleType>(reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToNode:
        try map.setToLastKey(reference)
    case .FromNode:
        break
    }
}

public func ~> <T: NodeConvertibleType>(reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .ToNode:
        try map.setToLastKey(reference)
    case .FromNode:
        break
    }
}

public func ~> <T: NodeConvertibleType>(reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .ToNode:
        try map.setToLastKey(reference)
    case .FromNode:
        break
    }
}

public func ~> <T: NodeConvertibleType>(reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .ToNode:
        try map.setToLastKey(reference)
    case .FromNode:
        break
    }
}

public func ~> <T : NodeConvertibleType>(reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .ToNode:
        try map.setToLastKey(reference)
    case .FromNode:
        break
    }
}

// MARK: FromNode

infix operator <~ {}

public func <~ <T: NodeConvertibleType>(inout reference: T, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: T!, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: T?, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: [T], map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: [T]?, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: [[T]], map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: [[T]]?, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: [String : T], map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: [String : T]?, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: [String : [T]], map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: [String : [T]]?, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: Set<T>, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertibleType>(inout reference: Set<T>?, map: Map) throws {
    switch map.type {
    case .ToNode:
        break
    case .FromNode:
        reference = try <~map
    }
}

// MARK: Two Way Operator

infix operator <~> {}

public func <~> <T: NodeConvertibleType>(inout reference: T, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: T!, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: T?, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: [T], map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: [T]!, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: [T]?, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: [[T]], map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: [[T]]?, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: [String : T], map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: [String : T]?, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: [String : [T]], map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: [String : [T]]?, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: Set<T>, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertibleType>(inout reference: Set<T>?, map: Map) throws {
    switch map.type {
    case .ToNode:
        try reference ~> map
    case .FromNode:
        try reference <~ map
    }
}
