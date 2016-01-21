//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: To Dna

extension CollectionType where Generator.Element: DnaConvertibleType {
    public func dnaRepresentation() throws -> Dna {
        let array = try map { try $0.dnaRepresentation() }
        return .from(array)
    }
}

extension Dictionary where Key: CustomStringConvertible, Value: DnaConvertibleType {
    public func dnaRepresentation() throws -> Dna {
        var mutable: [String : Dna] = [:]
        try self.forEach { key, value in
            mutable["\(key)"] = try value.dnaRepresentation()
        }
        return .ObjectValue(mutable)
    }
}
