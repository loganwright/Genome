//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

public enum NodeConvertibleError : ErrorType {
    case UnsupportedType(String)
    case UnableToConvert(node: Node, toType: String)
}

public enum MappingError : ErrorType {
    case UnableToMap(key: KeyType, error: ErrorType)
    case UnexpectedOperationType(String)
}

public enum SequenceError : ErrorType {
    case FoundNil(String)
    case UnexpectedValue(String)
}

public enum TransformationError : ErrorType {
    case UnexpectedInputType(String)
}

public enum RawConversionError : ErrorType {
    case UnableToConvertToNode
    case UnableToConvertFromNode(raw: Any, ofType: String, expected: String)
}
