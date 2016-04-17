//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

public struct Error {
    public enum NodeConvertibleError: ErrorProtocol {
        case UnsupportedType(String)
        case UnableToConvert(node: Node, to: String)
    }
    public enum MappingError: ErrorProtocol {
        case UnableToMap(key: KeyType, error: ErrorProtocol)
        case UnexpectedOperationType(got: Map.OperationType, expected: Map.OperationType)
    }
    public enum SequenceError: ErrorProtocol {
        case foundNil(key: KeyType, expected: String)
        case unexpected(value: Any, key: KeyType, expectedType: String, targetType: String)
    }

    static func unexpectedValue<T,U>(got value: Any, expected: T.Type, for key: KeyType, target: U.Type) -> SequenceError {
        return .unexpected(value: value,
                           key: key,
                           expectedType: "\(expected)",
                           targetType: "\(target)")
    }

    static func foundNil<T>(for key: KeyType, expected: T) -> SequenceError {
        return .foundNil(key: key, expected: "\(T.self)")
    }
}

public enum NodeConvertibleError: ErrorProtocol {
    case UnsupportedType(String)
    case UnableToConvert(node: Node, to: String)
}

public enum MappingError: ErrorProtocol {
    case UnableToMap(key: KeyType, error: ErrorProtocol)
    case UnexpectedOperationType(got: Map.OperationType, expected: Map.OperationType)
}

//public enum SequenceError: ErrorProtocol {
//    case FoundNil(key: KeyType, expected: String)
////    case UnexpectedValue(String)
////    case Unexpected(value: Any, expectedType: String, key: KeyType, targetType: String)
//}

public enum _SequenceError: ErrorProtocol {
}

/*
 private func unexpectedResult<T, U>(result: Any, expected: T.Type, keyPath: KeyType, targetType: U.Type) -> ErrorProtocol {
 let message = "Found: \(result) Expected: \(T.self) KeyPath: \(keyPath) TargetType: \(U.self)"
 let error = SequenceError.UnexpectedValue(message)
 return error
 }
 */

public enum TransformationError: ErrorProtocol {
    case UnexpectedInputType(String)
}

public enum RawConversionError: ErrorProtocol {
    case UnableToConvertToNode
    case UnableToConvertFromNode(raw: Any, ofType: String, expected: String)
}
