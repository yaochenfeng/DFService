import XCTest
@testable import DFService

final class DFServiceTests: XCTestCase {
    func testExample() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Application.version, "0.1.0")
        XCTAssertEqual(Application.shared[RuntimeService.self].isRunningInTests, true)
        
    }
    
    func testApiCalll() async throws {
    }
}
