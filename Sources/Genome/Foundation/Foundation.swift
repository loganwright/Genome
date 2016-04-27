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
    public init(with node: AnyObject, in context: [String : AnyObject] = [:]) throws {
        try self.init(node: Node(node), in: context)
    }
    
    public init(with node: [String : AnyObject], in context: [String : AnyObject] = [:]) throws {
        try self.init(node: Node(node), in: context)
    }
}
