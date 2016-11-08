
#if os(Linux)

import XCTest
@testable import PathIndexableTests

XCTMain([
    testCase(DictionaryKeyPathTests.allTests),
    testCase(PathIndexableTests.allTests),
])

#endif
