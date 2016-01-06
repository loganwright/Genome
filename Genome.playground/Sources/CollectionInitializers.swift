//
//  Initializers.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

// MARK: MappableObject Initialization

public extension Array where Element : JsonConvertibleType {
    public init(js: Json, context: Json = [:]) throws {
        let array = js.arrayValue ?? [js]
        try self.init(js: array, context: context)
    }
    
    public init(js: [Json], context: Json = [:]) throws {
        self = try js.map { try Element.newInstance($0, context: context) }
    }
}

public extension Set where Element : JsonConvertibleType {
    public init(js: Json, context: Json = [:]) throws {
        let array = js.arrayValue ?? [js]
        try self.init(js: array, context: context)
    }
    
    public init(js: [Json], context: Json = [:]) throws {
        let array = try js.map { try Element.newInstance($0, context: context) }
        self.init(array)
    }
}
