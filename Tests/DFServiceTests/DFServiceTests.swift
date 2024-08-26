import XCTest
@testable import DFService

final class DFServiceTests: XCTestCase {
    func testExample() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ServiceValues.version, "0.1.0")
        XCTAssertEqual(ServiceValues[RuntimeService.self].isRunningInTests, true)
        
    }
    
    func testApiCalll() async throws {
        
        ServiceValues.shared[.logger] = LogService.self
        try await ServiceName.logger(ApiCallConext(method: "debug", param: "你好呀"))
    }
}
