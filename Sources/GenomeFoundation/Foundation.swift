//
//  Map.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//
//  MIT

@_exported import Genome
import Foundation

#if Xcode
extension MappableObject {
    public init(node: AnyObject, in context: [String : AnyObject] = [:]) throws {
        try self.init(node: Node(node), in: Node(context))
    }
    
    public init(node: [String : AnyObject], in context: [String : AnyObject] = [:]) throws {
        try self.init(node: Node(node), in: context)
    }
}
#endif
