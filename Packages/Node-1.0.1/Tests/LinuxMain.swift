#if os(Linux)
import XCTest
@testable import NodeTests

XCTMain([
    testCase(BasicConvertibleTests.allTests),
    testCase(DictionaryKeyPathTests.allTests),
    testCase(NodeDataTypeTests.allTests),
    testCase(NodeExtractTests.allTests),
    testCase(NodeIndexableTests.allTests),
    testCase(NodePolymorphicTests.allTests),
    testCase(NodeTests.allTests),
    testCase(SequenceConvertibleTests.allTests),
    testCase(NumberTests.allTests),
    testCase(NodeBackedTests.allTests),
])
#endif
