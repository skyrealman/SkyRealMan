import XCTest
@testable import SkyRealMan

class SkyRealManTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(SkyRealMan().text, "Hello, World!")
    }


    static var allTests : [(String, (SkyRealManTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
