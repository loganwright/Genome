//
//  BackingDataType.swift
//  Genome
//
//  Created by Logan Wright on 2/10/16.
//  Copyright © 2016 lowriDevs. All rights reserved.
//

// MARK: BackingDataType 

/**
 *  Use this protocol for easy transformations to and from Node
 *
 *  Similar to NodeConvertibleType, but this is included to facilitate confident
 *  conversions between backing data and the internal Node type
 *  It's main difference is that it is a non-failable operation.
 *
 *  Backing data should always be representable as a Node.
*/
public protocol BackingDataType: Context {
    init(node: Node, context: Context)
    func toNode() -> Node
}

extension BackingDataType {
    public init(node: Node) {
        self.init(node: node, context: node)
    }
}

// MARK: Node

extension Node {
    public func toData<T: BackingDataType>() throws -> T {
        return T.init(node: self)
    }
}

// MARK: Node Convertible

extension NodeConvertibleType {
    public init<T: BackingDataType>(node data: T, context: Context = EmptyNode) throws {
        let node = data.toNode()
        try self.init(node: node, context: context)
    }
}

// MARK: Mappable Object

extension MappableObject {
    public init<T: BackingDataType>(node data: T, context: Context = EmptyNode) throws {
        self = try Self.makeWith(data, context: context)
    }
    
    static func makeWith<T: BackingDataType>(data: T, context: Context) throws -> Self {
        let node = data.toNode()
        guard let _ = node.objectValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        return try self.init(node: node, context: context)
    }
}
