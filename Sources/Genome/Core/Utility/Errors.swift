//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

public enum Error: ErrorProtocol {
    case unableToConvert(node: Node, to: String)
    case unexpectedOperation(got: Map.OperationType, expected: Map.OperationType)
    case foundNil(path: [NodeIndexable], expected: String)
    case unexpected(value: Any, path: [NodeIndexable], expectedType: String, targetType: String)
}

internal struct ErrorFactory {
    static func unexpectedValue<T,U>(got value: Any,
                                expected: T.Type,
                                for path: [NodeIndexable],
                                target: U.Type) -> Error {
        let error = Error.unexpected(value: value,
                                     path: path,
                                     expectedType: "\(expected)",
                                     targetType: "\(target)")
        return error.logged()
    }

    static func foundNil<T>(for path: [NodeIndexable], expected: T.Type) -> Error {
        let error = Error.foundNil(path: path,
                                   expected: "\(T.self)")
        return error.logged()
    }

    static func unableToConvert<T>(_ node: Node, to type: T.Type) -> Error {
        let error = Error.unableToConvert(node: node,
                                          to: "\(type)")
        return error.logged()
    }

    static func unexpectedOperation(got operation: Map.OperationType,
                                    expected: Map.OperationType) -> Error {
        let error = Error.unexpectedOperation(got: operation,
                                              expected: expected)
        return error.logged()
    }
}
