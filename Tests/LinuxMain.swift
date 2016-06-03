
#if os(Linux)

import XCTest
@testable import GenomeTestSuite

XCTMain([
    testCase(BasicTypeTests.allTests),
    testCase(DictionaryKeyPathTests.allTests),
    testCase(FromNodeOperatorTestBasic.allTests),
    testCase(FromNodeOperatorTestMapped.allTests),
    testCase(NodeDataTypeTest.allTests),
    testCase(NodeIndexable.allTests),
    testCase(SettableOperatorTest.allTests),
    testCase(ToNodeOperatorTest.allTests),
    testCase(TransformTest.allTests),
    testCase(JSONTest.allTests)
])

#endif
