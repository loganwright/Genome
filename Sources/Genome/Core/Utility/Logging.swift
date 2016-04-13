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

internal func logError(error: ErrorProtocol) -> ErrorProtocol {
    loggers.forEach {
        $0(error)
    }
    return error
}

internal func logError(error: NodeConvertibleError) -> ErrorProtocol {
    return logError(error as ErrorProtocol)
}

