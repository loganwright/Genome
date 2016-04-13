//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

public enum NodeConvertibleError: ErrorProtocol {
    case UnsupportedType(String)
    case UnableToConvert(node: Node, to: String)
}

public enum MappingError: ErrorProtocol {
    case UnableToMap(key: KeyType, error: ErrorProtocol)
    case UnexpectedOperationType(got: Map.OperationType, expected: Map.OperationType)
}

public enum SequenceError: ErrorProtocol {
    case FoundNil(key: KeyType, expected: String)
    case UnexpectedValue(String)
}

public enum TransformationError: ErrorProtocol {
    case UnexpectedInputType(String)
}

public enum RawConversionError: ErrorProtocol {
    case UnableToConvertToNode
    case UnableToConvertFromNode(raw: Any, ofType: String, expected: String)
}
