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
        let safeNode = Node(node)
        let safeContext = Node(context)
        try self.init(node: safeNode, context: safeContext)
    }
    
    public init(node: [String : AnyObject], context: [String : AnyObject] = [:]) throws {
        try self.init(node: node as AnyObject, context: context)
    }
}
