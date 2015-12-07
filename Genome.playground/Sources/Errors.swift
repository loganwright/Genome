
public enum MappingError : ErrorType {
    case _UnableToMap(key: KeyType, error: ErrorType)
    case UnableToMap(String)
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
    case UnableToConvertToJSON
    case UnableToConvertFromJSON(raw: Any, ofType: String, expected: String)
}
