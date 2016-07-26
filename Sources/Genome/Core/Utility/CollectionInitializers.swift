////
////  Genome
////
////  Created by Logan Wright
////  Copyright © 2016 lowriDevs. All rights reserved.
////
////  MIT
////
//
//// MARK: MappableObject Initialization
//
//public extension Array where Element : NodeConvertible {
//    public init<T: BackingData>(with data: T, in context: Context = EmptyNode) throws {
//        let node = try data.makeNode()
//        let array = node.array ?? [node]
//        try self.init(with: array, in: context)
//    }
//    
//    public init<T: BackingData>(with data: [T], in context: Context = EmptyNode) throws {
//        let node = try data.map { try $0.makeNode() }
//        self = try node.map { try Element.init(with: $0, in: context) }
//    }
//}
//
//public extension Set where Element : NodeConvertible {
//    public init<T: BackingData>(with data: T, in context: Context = EmptyNode) throws {
//        let node = try data.makeNode()
//        let array = node.array ?? [node]
//        try self.init(with: array, in: context)
//    }
//    
//    public init<T: BackingData>(with data: [T], in context: Context = EmptyNode) throws {
//        let nodes = try data.map { try $0.makeNode() }
//        let array = try nodes.map { try Element.init(with: $0, in: context) }
//        self.init(array)
//    }
//}
