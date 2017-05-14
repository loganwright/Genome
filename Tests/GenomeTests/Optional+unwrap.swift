//
//  Optional+unwrap.swift
//  Genome
//
//  Created by Tim Vermeulen on 14/05/2017.
//
//

extension Optional {
    enum Error: Swift.Error {
        case missingValue
    }
    
    func unwrap() throws -> Wrapped {
        guard let value = self else { throw Error.missingValue }
        return value
    }
}
