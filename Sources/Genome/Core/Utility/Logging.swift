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
    print("Genome.Error.\(error)")
}

extension ErrorProtocol {
    func logged() -> Self {
        loggers.forEach {
            $0(self)
        }
        return self
    }
}
