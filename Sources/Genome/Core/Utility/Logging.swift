//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

#if swift(>=3.0)
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
#else
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
#endif
