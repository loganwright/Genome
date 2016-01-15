//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

import PureJsonSerializer

// MARK: To Json

extension CollectionType where Generator.Element: JsonConvertibleType {
    public func jsonRepresentation() throws -> Json {
        let array = try map { try $0.jsonRepresentation() }
        return .from(array)
    }
}

extension Dictionary where Key: CustomStringConvertible, Value: JsonConvertibleType {
    public func jsonRepresentation() throws -> Json {
        var mutable: [String : Json] = [:]
        try self.forEach { key, value in
            mutable["\(key)"] = try value.jsonRepresentation()
        }
        return .ObjectValue(mutable)
    }
}
