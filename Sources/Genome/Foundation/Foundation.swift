//
//  Map.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//
//  MIT

import Foundation

extension MappableObject {
    public init(node: AnyObject, context: [String : AnyObject] = [:]) throws {
        let safeNode = try Node(node)
        try self.init(node: safeNode, context: context)
    }
    
    public init(node: [String : AnyObject], context: [String : AnyObject] = [:]) throws {
        try self.init(node: Node(node), context: context)
    }
}
