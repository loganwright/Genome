//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: MappableObject Initialization

public extension Array where Element : DnaConvertibleType {
    public init(js: Dna, context: Context = EmptyDna) throws {
        let array = js.arrayValue ?? [js]
        try self.init(js: array, context: context)
    }
    
    public init(js: [Dna], context: Context = EmptyDna) throws {
        self = try js.map { try Element.newInstance($0, context: context) }
    }
}

public extension Set where Element : DnaConvertibleType {
    public init(js: Dna, context: Context = EmptyDna) throws {
        let array = js.arrayValue ?? [js]
        try self.init(js: array, context: context)
    }
    
    public init(js: [Dna], context: Context = EmptyDna) throws {
        let array = try js.map { try Element.newInstance($0, context: context) }
        self.init(array)
    }
}
