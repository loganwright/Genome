
#if os(Linux)

import XCTest
@testable import GenomeTests
@testable import GenomeFoundationTests

XCTMain([
    // Genome
    testCase(BasicTypeTests.allTests),
    testCase(DictionaryKeyPathTests.allTests),
    testCase(FromNodeOperatorTestBasic.allTests),
    testCase(FromNodeOperatorTestMapped.allTests),
    testCase(NodeDataTypeTest.allTests),
    testCase(PathIndexable.allTests),
    testCase(SettableOperatorTest.allTests),
    testCase(ToNodeOperatorTest.allTests),
    testCase(TransformTest.allTests),

    // GenomeFoundation
    testCase(JSONTests.allTests),
    testCase(NodeFoundationTests.allTests),
])

#endif
