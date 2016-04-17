//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: MappableObject Initialization

public extension Array where Element : NodeConvertible {
    public init<T: BackingData>(node data: T, context: Context = EmptyNode) throws {
        let node = try data.makeNode()
        let array = node.arrayValue ?? [node]
        try self.init(node: array, context: context)
    }
    
    public init<T: BackingData>(node data: [T], context: Context = EmptyNode) throws {
        let node = try data.map { try $0.makeNode() }
        self = try node.map { try Element.init(node: $0, context: context) }
    }
}

public extension Set where Element : NodeConvertible {
    public init<T: BackingData>(node data: T, context: Context = EmptyNode) throws {
        let node = try data.makeNode()
        let array = node.arrayValue ?? [node]
        try self.init(node: array, context: context)
    }
    
    public init<T: BackingData>(node data: [T], context: Context = EmptyNode) throws {
        let node = try data.map { try $0.makeNode() }
        let array = try node.map { try Element.init(node: $0, context: context) }
        self.init(array)
    }
}
