
#if os(Linux)

import XCTest
@testable import GenomeTestSuite

XCTMain([
    testCase(BasicTypes.allTests),
    testCase(DictionaryKeyPathTests.allTests),
    testCase(FromNodeOperatorTest.allTests),
    testCase(NodeDataTypeTest.allTests),
    testCase(NodeIndexable.allTests),
    testCase(SettableOperatorTest.allTests),
    testCase(ToNodeOperatorTest.allTests),
    testCase(TransformTest.allTests)
])

#endif
