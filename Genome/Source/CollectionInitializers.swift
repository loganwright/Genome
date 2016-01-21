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
    public init(dna: Dna, context: Context = EmptyDna) throws {
        let array = dna.arrayValue ?? [dna]
        try self.init(dna: array, context: context)
    }
    
    public init(dna: [Dna], context: Context = EmptyDna) throws {
        self = try dna.map { try Element.newInstance($0, context: context) }
    }
}

public extension Set where Element : DnaConvertibleType {
    public init(dna: Dna, context: Context = EmptyDna) throws {
        let array = dna.arrayValue ?? [dna]
        try self.init(dna: array, context: context)
    }
    
    public init(dna: [Dna], context: Context = EmptyDna) throws {
        let array = try dna.map { try Element.newInstance($0, context: context) }
        self.init(array)
    }
}
