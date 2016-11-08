#if os(Linux)

    import XCTest
    @testable import PolymorphicTests

XCTMain([
    testCase(PolymorphicTests.allTests)
])
    
#endif
