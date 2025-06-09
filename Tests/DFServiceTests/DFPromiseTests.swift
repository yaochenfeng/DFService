//
//  DFService
//
//  Created by yaochenfeng on 2025/6/7.
//

import XCTest

@testable import DFService

final class DFPromiseTests: XCTestCase {
    
    func testPromiseResolvesImmediately() {
        let expectation = self.expectation(description: "Immediate resolve")
        let promise = DFPromise<String> { resolve, _ in
            resolve("immediate")
        }
        promise.then { value in
            XCTAssertEqual(value, "immediate")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testPromiseRejectsImmediately() {
        enum TestError: Error { case fail }
        let expectation = self.expectation(description: "Immediate reject")
        let promise = DFPromise<Int> { _, reject in
            reject(TestError.fail)
        }
        promise.catch { error in
            XCTAssertTrue(error is TestError)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testThenAfterResolve() {
        let expectation = self.expectation(description: "Then after resolve")
        let promise = DFPromise<Int>.resolve(5)
        promise.then { value in
            XCTAssertEqual(value, 5)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testCatchAfterReject() {
        enum TestError: Error { case fail }
        let expectation = self.expectation(description: "Catch after reject")
        let promise = DFPromise<Int>.reject(TestError.fail)
        promise.catch { error in
            XCTAssertTrue(error is TestError)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testFinallyAfterResolve() {
        let expectation = self.expectation(description: "Finally after resolve")
        let promise = DFPromise<Int>.resolve(1)
        promise.finally {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testFinallyAfterReject() {
        enum TestError: Error { case fail }
        let expectation = self.expectation(description: "Finally after reject")
        let promise = DFPromise<Int>.reject(TestError.fail)
        promise.finally {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testAllResolves() {
        let expectation = self.expectation(description: "All resolves")
        let p1 = DFPromise<Int>.resolve(1)
        let p2 = DFPromise<Int>.resolve(2)
        let p3 = DFPromise<Int>.resolve(3)
        DFPromise.all([p1, p2, p3]).then { values in
            XCTAssertEqual(values.sorted(), [1, 2, 3])
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testAllRejectsIfAnyFails() {
        enum TestError: Error { case fail }
        let expectation = self.expectation(description: "All rejects if any fails")
        let p1 = DFPromise<Int>.resolve(1)
        let p2 = DFPromise<Int>.reject(TestError.fail)
        let p3 = DFPromise<Int>.resolve(3)
        DFPromise.all([p1, p2, p3]).catch { error in
            XCTAssertTrue(error is TestError)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testAllEmptyArray() {
        let expectation = self.expectation(description: "All with empty array resolves immediately")
        DFPromise<Int>.all([]).then { values in
            XCTAssertEqual(values.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testThenThrowsError() {
        enum TestError: Error { case fail }
        let expectation = self.expectation(description: "Then throws error")
        let promise = DFPromise<Int>.resolve(1)
        promise.then { _ in
            throw TestError.fail
        }.catch { error in
            XCTAssertTrue(error is TestError)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testMultipleThenHandlers() {
        let expectation1 = self.expectation(description: "First then called")
        let expectation2 = self.expectation(description: "Second then called")
        let promise = DFPromise<String>.resolve("multi")
        promise.then { value in
            XCTAssertEqual(value, "multi")
            expectation1.fulfill()
        }
        promise.then { value in
            XCTAssertEqual(value, "multi")
            expectation2.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testMultipleCatchHandlers() {
        enum TestError: Error { case fail }
        let expectation1 = self.expectation(description: "First catch called")
        let expectation2 = self.expectation(description: "Second catch called")
        let promise = DFPromise<String>.reject(TestError.fail)
        promise.catch { error in
            XCTAssertTrue(error is TestError)
            expectation1.fulfill()
        }
        promise.catch { error in
            XCTAssertTrue(error is TestError)
            expectation2.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    func testPromiseResolvesSuccessfully() {
        let expectation = self.expectation(description: "Promise should resolve")
        let promise = DFPromise<Int> { resolve, _ in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                resolve(42)
            }
        }
        promise.then { value in
            XCTAssertEqual(value, 42)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testPromiseRejectsWithError() {
        enum TestError: Error { case fail }
        let expectation = self.expectation(description: "Promise should reject")
        let promise = DFPromise<Int> { _, reject in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                reject(TestError.fail)
            }
        }
        promise.catch { error in
            XCTAssertTrue(error is TestError)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testThenChaining() {
        let expectation = self.expectation(description: "Promise chain should resolve")
        let promise = DFPromise<Int> { resolve, _ in
            resolve(10)
        }
        promise
            .then { value -> Int in
                return value * 2
            }
            .then { value -> String in
                XCTAssertEqual(value, 20)
                return "Final value: \(value)"
            }
            .then { value -> String in
                XCTAssertEqual(value, "Final value: 20")
                return "20"
            }
            .then { value -> DFPromise<String> in
                return DFPromise<String> { resolve, _ in
                    resolve("Chained value: \(value)")
                }
            }.then { value in
                XCTAssertEqual(value, "Chained value: 20")
                expectation.fulfill()
            }
        waitForExpectations(timeout: 1)
    }

    func testCatchAfterThen() {
        enum TestError: Error { case fail }
        let expectation = self.expectation(description: "Promise should catch error after then")
        let promise = DFPromise<Int> { _, reject in
            reject(TestError.fail)
        }
        promise
            .then { value in
                XCTFail("Should not be called")
            }
            .catch { error in
                XCTAssertTrue(error is TestError)
                expectation.fulfill()
            }
        waitForExpectations(timeout: 1)
    }

    func testFinallyCalledOnFulfill() {
        let expectation = self.expectation(description: "Finally should be called on fulfill")
        let promise = DFPromise<String> { resolve, _ in
            resolve("done")
        }
        promise.finally {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testFinallyCalledOnReject() {
        enum TestError: Error { case fail }
        let expectation = self.expectation(description: "Finally should be called on reject")
        let promise = DFPromise<String> { _, reject in
            reject(TestError.fail)
        }
        promise.finally {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testResolveWithValue() {
        let promise = DFPromise<Int>.resolve(100)

        XCTAssertEqual(promise.value, 100)
    }
    func testRejectWithError() {
        enum TestError: Error { case fail }
        let promise = DFPromise<Int>.reject(TestError.fail)

        XCTAssertNil(promise.value)
        XCTAssertTrue(!promise.isPending)
    }

    func testAllAndOrder() {
        let expectation = self.expectation(description: "All resolves in order")
        let p1 = DFPromise<Int>.resolve(1)
        let p2 = DFPromise<Int>.resolve(2)
        let p3 = DFPromise<Int>.resolve(3)

        DFPromise.all([p1, p2, p3]).then { values in
            XCTAssertEqual(values, [1, 2, 3])
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
    func testAllAsyncAndOrder() {
        let expectation = self.expectation(description: "All resolves in order with async")
        let p1 = DFPromise<Int> { resolve, _ in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                resolve(1)
            }
        }
        let p2 = DFPromise<Int> { resolve, _ in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                resolve(2)
            }
        }
        let p3 = DFPromise<Int> { resolve, _ in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
                resolve(3)
            }
        }

        DFPromise.all([p1, p2, p3]).then { values in
            XCTAssertEqual(values, [1, 2, 3])
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    @available(macOS 10.15, iOS 13.0, *)
    func testAsyncInitAndWait() async throws {
        let promise = DFPromise<Int> {
            try await Task.sleep(nanoseconds: 100_000_000)
            return 99
        }
        let value = try await promise.wait()
        XCTAssertEqual(value, 99)
    }

}
