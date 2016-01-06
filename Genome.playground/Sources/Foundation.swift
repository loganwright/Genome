//
//  Map.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

extension MappableObject {
    public static func mappedInstance(js: [String : AnyObject], context: [String : AnyObject] = [:]) throws -> Self {
        return try mappedInstance(Json.from(js), context: Json.from(context))
    }
}

extension BasicMappable {
    public init(js: AnyObject, context: [String : AnyObject] = [:]) throws {
        let safeJson = Json.from(js)
        let safeContext = Json.from(context)
        try self.init(js: safeJson, context: safeContext)
    }
    
    public init(js: [String : AnyObject], context: [String : AnyObject] = [:]) throws {
        try self.init(js: js as AnyObject, context: context)
    }
}

extension StandardMappable {
    public init(js: AnyObject, context: [String : AnyObject] = [:]) throws {
        let safeJson = Json.from(js)
        let safeContext = Json.from(context)
        try self.init(js: safeJson, context: safeContext)
    }
    
    public init(js: [String : AnyObject], context: [String : AnyObject] = [:]) throws {
        try self.init(js: js as AnyObject, context: context)
    }
}