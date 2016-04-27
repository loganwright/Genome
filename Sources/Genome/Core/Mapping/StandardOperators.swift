//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: ToNode

public func ~> <T : NodeConvertible>(reference: T!, map: Map) throws {
    switch map.type {
    case .toNode:
        try map.setToLastPath(reference)
    case .fromNode:
        break
    }
}

public func ~> <T: NodeConvertible>(reference: [T]!, map: Map) throws {
    switch map.type {
    case .toNode:
        try map.setToLastPath(reference)
    case .fromNode:
        break
    }
}

public func ~> <T: NodeConvertible>(reference: [[T]]!, map: Map) throws {
    switch map.type {
    case .toNode:
        try map.setToLastPath(reference)
    case .fromNode:
        break
    }
}

public func ~> <T: NodeConvertible>(reference: [String : T]!, map: Map) throws {
    switch map.type {
    case .toNode:
        try map.setToLastPath(reference)
    case .fromNode:
        break
    }
}

public func ~> <T: NodeConvertible>(reference: [String : [T]]!, map: Map) throws {
    switch map.type {
    case .toNode:
        try map.setToLastPath(reference)
    case .fromNode:
        break
    }
}

public func ~> <T : NodeConvertible>(reference: Set<T>!, map: Map) throws {
    switch map.type {
    case .toNode:
        try map.setToLastPath(reference)
    case .fromNode:
        break
    }
}

// MARK: FromNode

infix operator <~ {}

public func <~ <T: NodeConvertible>(reference: inout T, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout T!, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout T?, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout [T], map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout [T]!, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout [T]?, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout [[T]], map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout [[T]]!, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout [[T]]?, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout [String : T], map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout [String : T]!, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout [String : T]?, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout [String : [T]], map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout [String : [T]]!, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout [String : [T]]?, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout Set<T>, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout Set<T>!, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

public func <~ <T: NodeConvertible>(reference: inout Set<T>?, map: Map) throws {
    switch map.type {
    case .toNode:
        break
    case .fromNode:
        reference = try <~map
    }
}

// MARK: Two Way Operator

infix operator <~> {}

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
