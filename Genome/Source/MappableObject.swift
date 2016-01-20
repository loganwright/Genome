//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

import PureJsonSerializer

// MARK: MappableBase

public protocol MappableBase : JsonConvertibleType {
    mutating func sequence(map: Map) throws -> Void
}

extension MappableBase {
    
    /// Used to convert an object back into json
    public func jsonRepresentation() throws -> Json {
        let map = Map()
        var mutable = self
        try mutable.sequence(map)
        return map.toJson
    }
}

// MARK: MappableObject

public protocol MappableObject: MappableBase {
    init(map: Map) throws
}

extension MappableObject {
    public func sequence(map: Map) throws { }
    
    public init(js: Json, context: Context = EmptyJson) throws {
        let map = Map(json: js, context: context)
        try self.init(map: map)
    }
    
    // JsonConvertibleTypeConformance
    public static func newInstance(json: Json, context: Context = EmptyJson) throws -> Self {
        guard let _ = json.objectValue else {
            throw logError(JsonConvertibleError.UnableToConvert(json: json, toType: "\(self)"))
        }
        return try self.init(js: json, context: context)
    }
}

// MARK: Basic Mappable

/**
*  If you are using a simple object that can take an empty initializer
*  it should conform to this protocol.protocol
*/
public protocol BasicMappable: MappableObject {
    init() throws
}

extension BasicMappable {
    public init(map: Map) throws {
        try self.init()
        try sequence(map)
    }
}

// MARK: Inheritable Object

public class Object : MappableObject {
    required public init(map: Map) throws {}
    
    public func sequence(map: Map) throws {}
    
    public static func newInstance(json: Json, context: Context) throws -> Self {
        let map = Map(json: json, context: context)
        let new = try self.init(map: map)
        return new
    }
}
