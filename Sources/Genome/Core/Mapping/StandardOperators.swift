//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: ToNode

#if swift(>=3.0)    
    public func ~> <T : NodeConvertible>(reference: T!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try map.setToLastKey(reference)
        case .FromNode:
            break
        }
    }
    
    public func ~> <T: NodeConvertible>(reference: [T]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try map.setToLastKey(reference)
        case .FromNode:
            break
        }
    }
    
    public func ~> <T: NodeConvertible>(reference: [[T]]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try map.setToLastKey(reference)
        case .FromNode:
            break
        }
    }
    
    public func ~> <T: NodeConvertible>(reference: [String : T]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try map.setToLastKey(reference)
        case .FromNode:
            break
        }
    }
    
    public func ~> <T: NodeConvertible>(reference: [String : [T]]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try map.setToLastKey(reference)
        case .FromNode:
            break
        }
    }
    
    public func ~> <T : NodeConvertible>(reference: Set<T>!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try map.setToLastKey(reference)
        case .FromNode:
            break
        }
    }
    
    // MARK: FromNode
    
    infix operator <~ {}
    
    public func <~ <T: NodeConvertible>(reference: inout T, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout T!, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout T?, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout [T], map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout [T]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout [T]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout [[T]], map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout [[T]]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout [[T]]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout [String : T], map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout [String : T]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout [String : T]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout [String : [T]], map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout [String : [T]]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout [String : [T]]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout Set<T>, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout Set<T>!, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(reference: inout Set<T>?, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    // MARK: Two Way Operator
    
    infix operator <~> {}
    
    public func <~> <T: NodeConvertible>(reference: inout T, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout T!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout T?, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout [T], map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout [T]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout [T]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout [[T]], map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout [[T]]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout [[T]]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout [String : T], map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout [String : T]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout [String : T]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout [String : [T]], map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout [String : [T]]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout [String : [T]]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout Set<T>, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout Set<T>!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(reference: inout Set<T>?, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
#else
    public func ~> <T : NodeConvertible>(reference: T!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try map.setToLastKey(reference)
        case .FromNode:
            break
        }
    }
    
    public func ~> <T: NodeConvertible>(reference: [T]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try map.setToLastKey(reference)
        case .FromNode:
            break
        }
    }
    
    public func ~> <T: NodeConvertible>(reference: [[T]]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try map.setToLastKey(reference)
        case .FromNode:
            break
        }
    }
    
    public func ~> <T: NodeConvertible>(reference: [String : T]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try map.setToLastKey(reference)
        case .FromNode:
            break
        }
    }
    
    public func ~> <T: NodeConvertible>(reference: [String : [T]]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try map.setToLastKey(reference)
        case .FromNode:
            break
        }
    }
    
    public func ~> <T : NodeConvertible>(reference: Set<T>!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try map.setToLastKey(reference)
        case .FromNode:
            break
        }
    }
    
    // MARK: FromNode
    
    infix operator <~ {}
    
    public func <~ <T: NodeConvertible>(inout reference: T, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: T!, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: T?, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: [T], map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: [T]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: [T]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: [[T]], map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: [[T]]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: [[T]]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: [String : T], map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: [String : T]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: [String : T]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: [String : [T]], map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: [String : [T]]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: [String : [T]]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: Set<T>, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: Set<T>!, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    public func <~ <T: NodeConvertible>(inout reference: Set<T>?, map: Map) throws {
        switch map.type {
        case .ToNode:
            break
        case .FromNode:
            reference = try <~map
        }
    }
    
    // MARK: Two Way Operator
    
    infix operator <~> {}
    
    public func <~> <T: NodeConvertible>(inout reference: T, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: T!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: T?, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: [T], map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: [T]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: [T]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: [[T]], map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: [[T]]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: [[T]]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: [String : T], map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: [String : T]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: [String : T]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: [String : [T]], map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: [String : [T]]!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: [String : [T]]?, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: Set<T>, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: Set<T>!, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
    public func <~> <T: NodeConvertible>(inout reference: Set<T>?, map: Map) throws {
        switch map.type {
        case .ToNode:
            try reference ~> map
        case .FromNode:
            try reference <~ map
        }
    }
    
#endif