//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

public var loggers: [ErrorProtocol -> Void] = [defaultLogger]

private func defaultLogger(error: ErrorProtocol) {
    print(error)
}

internal func log(error: ErrorProtocol) -> ErrorProtocol {
    loggers.forEach {
        $0(error)
    }
    return error
}

internal func log(error: NodeConvertibleError) -> ErrorProtocol {
    return log(error as ErrorProtocol)
}

internal func log(error: MappingError) -> ErrorProtocol {
    return log(error as ErrorProtocol)
}

internal func log(error: SequenceError) -> ErrorProtocol {
    return log(error as ErrorProtocol)
}

internal func log(error: TransformationError) -> ErrorProtocol {
    return log(error as ErrorProtocol)
}

internal func log(error: RawConversionError) -> ErrorProtocol {
    return log(error as ErrorProtocol)
}
