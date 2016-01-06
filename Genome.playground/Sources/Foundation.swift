//
//  Map.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

extension MappableObject {
    static func mappedInstance(js: [String : AnyObject], context: [String : AnyObject] = [:]) throws -> Self {
        return try mappedInstance(Json.from(js), context: Json.from(context))
    }
}
