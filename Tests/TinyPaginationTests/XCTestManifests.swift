import XCTest

#if !canImport(ObjectiveC)

public func allTests() -> [XCTestCaseEntry] {
    
    [
        testCase(PageManagerTests.allTests),
        testCase(TableTests.allTests),
    ]
    
}

#endif
