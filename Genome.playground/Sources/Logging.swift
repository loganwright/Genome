
public var loggers: [ErrorType -> Void] = [defaultLogger]

private func defaultLogger(error: ErrorType) {
    print(error)
}

internal func logError(error: ErrorType) -> ErrorType {
    loggers.forEach {
        $0(error)
    }
    return error
}
