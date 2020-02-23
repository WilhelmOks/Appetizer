import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SPM_ProjectTests.allTests),
    ]
}
#endif
