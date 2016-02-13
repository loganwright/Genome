//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

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
