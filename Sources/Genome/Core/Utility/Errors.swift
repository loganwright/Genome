//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

public enum Error: Swift.Error {
    /**
     Genome found `nil` somewhere that it wasn't expecting

     @param [PathIndexable] the path that was being mapped
     @param String          the type that was being targeted for given path
     */
    case foundNil(path: [PathIndex], targeting: String)

    /**
     Genome was unable to convert a given node to the target type

     @param Node            the node that was unable to convert
     @param String          a description of the type Genome was trying to convert to
     @param [PathIndexable] current path being mapped if applicable
     */
    case unableToConvert(node: Node, targeting: String, path: [PathIndex])

    /**
     Genome found that the `map` was prepared for an unexpected operation.
     
     ie: map is mapping from node, but tried an operation exclusive to `toNode`

     @param Map.OperationType the operation found
     @param Map.OperationType the operation expected to be found
     */
    case unexpectedOperation(got: Map.OperationType, expected: Map.OperationType)
}

extension Error {
    internal func appendLastKeyPath(_ lastKeyPath: [PathIndex]) -> Error {
        guard
            case let .unableToConvert(node: node,
                                      targeting: targeting,
                                      path: currentPath) = self,
            currentPath.isEmpty
            else { return self }

        let new = Error.unableToConvert(node: node, targeting: targeting, path: lastKeyPath)
        return new.logged()
    }
}

internal struct ErrorFactory {
    static func foundNil<T>(for path: [PathIndex], expected: T.Type) -> Error {
        let error = Error.foundNil(path: path,
                                   targeting: "\(T.self)")
        return error.logged()
    }

    static func unableToConvert<T>(_ node: Node,
                                   to type: T.Type) -> Error {
        let error = Error.unableToConvert(node: node,
                                          targeting: "\(type)",
                                          path: [])
        return error.logged()
    }

    static func unexpectedOperation(got operation: Map.OperationType,
                                    expected: Map.OperationType) -> Error {
        let error = Error.unexpectedOperation(got: operation,
                                              expected: expected)
        return error.logged()
    }
}
