//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

public var loggers: [(Swift.Error) -> Void] = [defaultLogger]

private func defaultLogger(error: Swift.Error) {
    print("Genome.Error.\(error)")
}

extension Swift.Error {
    func logged() -> Self {
        loggers.forEach {
            $0(self)
        }
        return self
    }
}
