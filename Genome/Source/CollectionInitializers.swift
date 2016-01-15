//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

import PureJsonSerializer

// MARK: MappableObject Initialization

public extension Array where Element : JsonConvertibleType {
    public init(js: Json, context: Context = EmptyJson) throws {
        let array = js.arrayValue ?? [js]
        try self.init(js: array, context: context)
    }
    
    public init(js: [Json], context: Context = EmptyJson) throws {
        self = try js.map { try Element.newInstance($0, context: context) }
    }
}

public extension Set where Element : JsonConvertibleType {
    public init(js: Json, context: Context = EmptyJson) throws {
        let array = js.arrayValue ?? [js]
        try self.init(js: array, context: context)
    }
    
    public init(js: [Json], context: Context = EmptyJson) throws {
        let array = try js.map { try Element.newInstance($0, context: context) }
        self.init(array)
    }
}
