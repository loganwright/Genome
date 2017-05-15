//
//  Optional+unwrap.swift
//  Genome
//
//  Created by Tim Vermeulen on 14/05/2017.
//
//

enum OptionalError: Swift.Error {
    case missingValue
}

extension Optional {
    func unwrap() throws -> Wrapped {
        guard let value = self else { throw OptionalError.missingValue }
        return value
    }
}
