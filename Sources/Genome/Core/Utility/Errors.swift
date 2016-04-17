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
        case UnableToMap(key: Key, error: ErrorProtocol)
        case UnexpectedOperationType(got: Map.OperationType, expected: Map.OperationType)
    }
    public enum SequenceError: ErrorProtocol {
        case foundNil(key: Key, expected: String)
        case unexpected(value: Any, key: Key, expectedType: String, targetType: String)
    }

    static func unexpectedValue<T,U>(got value: Any, expected: T.Type, for key: Key, target: U.Type) -> SequenceError {
        return .unexpected(value: value,
                           key: key,
                           expectedType: "\(expected)",
                           targetType: "\(target)")
    }

    static func foundNil<T>(for key: Key, expected: T) -> SequenceError {
        return .foundNil(key: key, expected: "\(T.self)")
    }
}

public enum NodeConvertibleError: ErrorProtocol {
    case UnsupportedType(String)
    case UnableToConvert(node: Node, to: String)
}

public enum MappingError: ErrorProtocol {
    case UnableToMap(key: Key, error: ErrorProtocol)
    case UnexpectedOperationType(got: Map.OperationType, expected: Map.OperationType)
}

public enum _SequenceError: ErrorProtocol {
}

public enum TransformationError: ErrorProtocol {
    case UnexpectedInputType(String)
}

public enum RawConversionError: ErrorProtocol {
    case UnableToConvertToNode
    case UnableToConvertFromNode(raw: Any, ofType: String, expected: String)
}
