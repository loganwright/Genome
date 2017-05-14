// MARK: ToNode

public func ~> <T : NodeConvertible>(reference: T!, map: Map) throws {
    switch map.type {
    case .toNode:
        try map.setToPath(reference)
    case .fromNode:
        break
    }
}

public func ~> <T: NodeConvertible>(reference: [T]!, map: Map) throws {
    switch map.type {
    case .toNode:
        try map.setToPath(reference)
    case .fromNode:
        break
    }
}

public func ~> <T: NodeConvertible>(reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .toNode:
        try map.setToPath(reference)
    case .fromNode:
        break
    }
}

public func ~> <T: NodeConvertible>(reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .toNode:
        try map.setToPath(reference)
    case .fromNode:
        break
    }
}

public func ~> <T: NodeConvertible>(reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .toNode:
        try map.setToPath(reference)
    case .fromNode:
        break
    }
}

public func ~> <T : NodeConvertible>(reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .toNode:
        try map.setToPath(reference)
    case .fromNode:
        break
    }
}

// MARK: FromNode

infix operator <~

public func <~ <T: NodeInitializable>(reference: inout T, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout T!, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout T?, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout [T], map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout [T]!, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout [T]?, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout [[T]], map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout [[T]]!, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout [[T]]?, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout [String : T], map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout [String : T]!, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout [String : T]?, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout [String : [T]], map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout [String : [T]]!, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout [String : [T]]?, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout Set<T>, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout Set<T>!, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

public func <~ <T: NodeInitializable>(reference: inout Set<T>?, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try map.extract(map.path)
    }
}

// MARK: Two Way Operator

infix operator <~>

public func <~> <T: NodeConvertible>(reference: inout T, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout T!, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout T?, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout [T], map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout [T]!, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout [T]?, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout [[T]], map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout [[T]]!, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout [[T]]?, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout [String : T], map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout [String : T]!, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout [String : T]?, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout [String : [T]], map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout [String : [T]]!, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout [String : [T]]?, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout Set<T>, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout Set<T>!, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}

public func <~> <T: NodeConvertible>(reference: inout Set<T>?, map: Map) throws {
    switch map.type {
    case .toNode:
        try reference ~> map
    case .fromNode:
        try reference <~ map
    }
}
