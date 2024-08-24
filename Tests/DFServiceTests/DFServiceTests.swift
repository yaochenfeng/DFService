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
        let mockLog = MockLog()
        
        ServiceValues.shared[.logger] = LogService.self
        ServiceValues.shared[LogService.self] = mockLog
        ServiceValues.shared[LogService.self, "hello"] = mockLog
        try await ServiceName.logger(ApiCallConext(method: "debug", param: "你好呀"))
    }
}


class MockLog: DFLogHandle, DFApiCall {
    func callAsFunction(_ context: DFService.ApiCallConext) async throws -> Any {
        return ()
    }
    
    func debug(_ msg: String) {
        
    }

}
