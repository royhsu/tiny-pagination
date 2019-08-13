import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MessageServiceTests.allTests),
        testCase(PageManagerTests.allTests),
        testCase(TableTests.allTests),
    ]
}
#endif
