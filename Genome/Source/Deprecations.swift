//
//  Deprecations.swift
//  Genome
//
//  Created by Logan Wright on 2/11/16.
//  Copyright © 2016 lowriDevs. All rights reserved.
//

extension Map {
    // Deprecation
    @available(*, deprecated=3.0, renamed="node")
    public var toNode: Node {
        return node
    }
}
