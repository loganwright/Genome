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
    public init<T: BackingDataType>(_ data: T, context: Context = EmptyNode) throws {
        let array = data.arrayValue ?? [data]
        try self.init(data: array, context: context)
    }
    
    public init<T: BackingDataType>(data: [T], context: Context = EmptyNode) throws {
        self = try data.map { try Element.newInstance($0, context: context) }
    }
}

public extension Set where Element : NodeConvertibleType {
    public init<T: BackingDataType>(data: T, context: Context = EmptyNode) throws {
        let array = data.arrayValue ?? [data]
        try self.init(node: array, context: context)
    }
    
    public init<T: BackingDataType>(node: [T], context: Context = EmptyNode) throws {
        let array = try node.map { try Element.newInstance($0, context: context) }
        self.init(array)
    }
}
