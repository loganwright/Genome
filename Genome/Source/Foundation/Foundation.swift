//
//  Map.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//
//  MIT

extension MappableObject {
    public init(dna: AnyObject, context: [String : AnyObject] = [:]) throws {
        let safeDna = Dna.from(dna)
        let safeContext = Dna.from(context)
        try self.init(dna: safeDna, context: safeContext)
    }
    
    public init(dna: [String : AnyObject], context: [String : AnyObject] = [:]) throws {
        try self.init(dna: dna as AnyObject, context: context)
    }
}
