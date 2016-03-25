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
    static func makeWith(node: Node, context: Context) -> Self
    func toNode() -> Node
}

extension BackingDataType {
    static func makeWith(node: Node) -> Self {
        return makeWith(node, context: node)
    }
}

// MARK: Node

extension Node {
    public func toData<T: BackingDataType>() throws -> T {
        return T.makeWith(self)
    }
}

// MARK: Node Convertible

extension NodeConvertibleType {
    static func makeWith<T: BackingDataType>(node data: T) throws -> Self {
        let node = data.toNode()
        return try makeWith(node, context: node)
    }
}

// MARK: Mappable Object

extension MappableObject {
    public init<T: BackingDataType>(node data: T, context: Context = EmptyNode) throws {
        let node = data.toNode()
        try self.init(node: node, context: context)
    }
    
    // NodeConvertibleTypeConformance
    public static func makeWith<T: BackingDataType>(data data: T, context: Context = EmptyNode) throws -> Self {
        let node = data.toNode()
        guard let _ = node.objectValue else {
            throw logError(NodeConvertibleError.UnableToConvert(node: node, toType: "\(self)"))
        }
        return try self.init(node: node, context: context)
    }
}
