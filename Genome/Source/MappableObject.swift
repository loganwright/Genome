//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: MappableBase

public protocol MappableBase : DnaConvertibleType {
    mutating func sequence(map: Map) throws -> Void
}

extension MappableBase {
    
    /// Used to convert an object back into dna
    public func dnaRepresentation() throws -> Dna {
        let map = Map()
        var mutable = self
        try mutable.sequence(map)
        return map.toDna
    }
}

// MARK: MappableObject

public protocol MappableObject: MappableBase {
    init(map: Map) throws
}

extension MappableObject {
    public func sequence(map: Map) throws { }
    
    public init(dna: Dna, context: Context = EmptyDna) throws {
        let map = Map(dna: dna, context: context)
        try self.init(map: map)
    }
    
    // DnaConvertibleTypeConformance
    public static func newInstance(dna: Dna, context: Context = EmptyDna) throws -> Self {
        guard let _ = dna.objectValue else {
            throw logError(DnaConvertibleError.UnableToConvert(dna: dna, toType: "\(self)"))
        }
        return try self.init(dna: dna, context: context)
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
    
    public static func newInstance(dna: Dna, context: Context) throws -> Self {
        let map = Map(dna: dna, context: context)
        let new = try self.init(map: map)
        return new
    }
}
