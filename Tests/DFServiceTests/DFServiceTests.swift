import XCTest
@testable import DFService

final class DFServiceTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertTrue(DF.isShared)
    }
    /// 环境变量测试
    func testEnv() throws {
        DF[env: \.isUnitTests] = false
        XCTAssertTrue(DF[env: \.isUnitTests])
        DF[env: \.current] = "test"
        print(DF.getEnvironments())
    }
    
    func testIOC() throws {
        let value: String = "hello"
        DF.register {
            value
        }
        XCTAssertEqual(value, try DF.resolve())
    }
}
