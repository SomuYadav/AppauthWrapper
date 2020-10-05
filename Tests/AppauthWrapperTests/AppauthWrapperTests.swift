
#if canImport(UIKit)
import XCTest
@testable import AppauthWrapper

final class AppauthWrapperTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AppauthWrapper().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
#endif
