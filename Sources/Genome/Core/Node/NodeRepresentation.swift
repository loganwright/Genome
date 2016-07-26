////
////  Genome
////
////  Created by Logan Wright
////  Copyright © 2016 lowriDevs. All rights reserved.
////
////  MIT
////
//
//// MARK: To Node
//
//extension Sequence where Iterator.Element: NodeConvertible {
//    public func makeNode() throws -> Node {
//        let array = try map { try $0.makeNode() }
//        return Node(array)
//    }
//    public func toData<T: BackingData>(type: T.Type = T.self) throws -> T {
//        return try makeNode().toData()
//    }
//}
//
//extension Dictionary where Key: CustomStringConvertible, Value: NodeConvertible {
//    public func makeNode() throws -> Node {
//        var mutable: [String : Node] = [:]
//        try self.forEach { key, value in
//            mutable["\(key)"] = try value.makeNode()
//        }
//        return .object(mutable)
//    }
//
//    public func toData<T: BackingData>(type: T.Type = T.self) throws -> Node {
//        return try makeNode().toData()
//    }
//}
