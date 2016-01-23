//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: MappableObject Initialization

public extension Array where Element : NodeConvertibleType {
    public init(node: Node, context: Context = EmptyNode) throws {
        let array = node.arrayValue ?? [node]
        try self.init(node: array, context: context)
    }
    
    public init(node: [Node], context: Context = EmptyNode) throws {
        self = try node.map { try Element.newInstance($0, context: context) }
    }
}

public extension Set where Element : NodeConvertibleType {
    public init(node: Node, context: Context = EmptyNode) throws {
        let array = node.arrayValue ?? [node]
        try self.init(node: array, context: context)
    }
    
    public init(node: [Node], context: Context = EmptyNode) throws {
        let array = try node.map { try Element.newInstance($0, context: context) }
        self.init(array)
    }
}
