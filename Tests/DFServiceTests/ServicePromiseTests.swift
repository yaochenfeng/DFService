//
//  ServicePromiseTests.swift
//  DFService
//
//  Created by yaochenfeng on 2025/6/7.
//

import XCTest

@testable import DFService

final class ServicePromiseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testPromiseResolvesSuccessfully() {
        let expectation = self.expectation(description: "Promise should resolve")
        let promise = ServicePromise<Int> { resolve, _ in
            resolve(10)
        }
        var result: Int?
        promise.then { value in
            result = value
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertEqual(result, 10)
        XCTAssertEqual(promise.state, .fulfilled)
    }

    func testPromiseRejectsWithError() {
        let expectation = self.expectation(description: "Promise should reject")
        let promise = ServicePromise<Int> { _, reject in
            reject(NSError(domain: "Test", code: 123, userInfo: nil))
        }
        var receivedError: Error?
        promise.catch { error in
            receivedError = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(receivedError)
        XCTAssertEqual(promise.state, .rejected)
    }

    func testPromiseFinallyCalledOnResolve() {
        let expectation = self.expectation(description: "Finally should be called")
        let promise = ServicePromise<Int> { resolve, _ in
            resolve(5)
        }
        var finallyCalled = false
        promise.finally {
            finallyCalled = true
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertTrue(finallyCalled)
    }

    func testPromiseFinallyCalledOnReject() {
        let expectation = self.expectation(description: "Finally should be called on reject")
        let promise = ServicePromise<Int> { _, reject in
            reject(NSError(domain: "Test", code: 1, userInfo: nil))
        }
        var finallyCalled = false
        promise.finally {
            finallyCalled = true
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertTrue(finallyCalled)
    }

    func testPromiseCancel() {
        let expectation = self.expectation(description: "Cancel handler should be called")
        let promise = ServicePromise<Int> { _, _ in }
        var cancelCalled = false
        promise.onCancel {
            cancelCalled = true
            expectation.fulfill()
        }
        promise.cancel()
        waitForExpectations(timeout: 1)
        XCTAssertTrue(cancelCalled)
        XCTAssertEqual(promise.state, .cancelled)
    }

    func testThenCalledImmediatelyIfAlreadyResolved() {
        let promise = ServicePromise<Int> { resolve, _ in
            resolve(99)
        }
        var value: Int?
        let _ = promise.then { v in
            value = v
        }
        XCTAssertEqual(value, 99)
    }

    func testCatchCalledImmediatelyIfAlreadyRejected() {
        let promise = ServicePromise<Int> { _, reject in
            reject(NSError(domain: "Test", code: 2, userInfo: nil))
        }
        var error: Error?
        let _ = promise.catch { e in
            error = e
        }
        XCTAssertNotNil(error)
    }

    func testFinallyCalledImmediatelyIfAlreadyResolved() {
        let promise = ServicePromise<Int> { resolve, _ in
            resolve(42)
        }
        var finallyCalled = false
        let _ = promise.finally {
            finallyCalled = true
        }
        XCTAssertTrue(finallyCalled)
    }
    func testFinallyCalledImmediatelyIfAlreadyRejected() {
        let promise = ServicePromise<Int> { _, reject in
            reject(NSError(domain: "Test", code: 3, userInfo: nil))
        }
        var finallyCalled = false
        let _ = promise.finally {
            finallyCalled = true
        }
        XCTAssertTrue(finallyCalled)
    }
    func testOnCancelCalledImmediatelyIfAlreadyCancelled() {
        let promise = ServicePromise<Int> { _, _ in }
        var cancelCalled = false
        let _ = promise.onCancel {
            cancelCalled = true
        }
        promise.cancel()
        XCTAssertTrue(cancelCalled)
    }
    func testOnCancelNotCalledIfPromiseNotCancelled() {
        let promise = ServicePromise<Int> { _, _ in }
        var cancelCalled = false
        let _ = promise.onCancel {
            cancelCalled = true
        }
        XCTAssertFalse(cancelCalled)
    }
    func testThenAfterResolve() {
        let expectation = self.expectation(description: "Then should be called after resolve")
        let promise = ServicePromise<Int> { resolve, _ in
            resolve(20)
        }
        var value: Int?
        promise.then { v in
            value = v
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertEqual(value, 20)
    }
    func testThenAfterReject() {
        let expectation = self.expectation(description: "Then should not be called after reject")
        let promise = ServicePromise<Int> { _, reject in

            reject(NSError(domain: "Test", code: 4, userInfo: nil))
        }
        var value: Int?
        promise.then { v in
            value = v
            expectation.fulfill()
        }.catch { _ in
            // Catch block should be called, not then
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertNil(value)
        XCTAssertEqual(promise.state, .rejected)

    }

}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension ServicePromiseTests {
    func testAsyncToPromise() async throws {
        //        let expectation = self.expectation(description: "Async promise should resolve")
        var result: Int?
        let promise = ServicePromise.fromAsync { () async throws -> Int in
            try await Task.sleep(nanoseconds: 500_000_000)  // 0.5 seconds
            return 42
        }
        result = try await promise.toAsync()
        //        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(result, 42)

        print("Async promise resolved with value: \(result ?? 0)")

    }
    func testPromiseToAsync() async throws {
        let expectation = self.expectation(description: "Async promise should resolve")

        let promise = ServicePromise<Int> { resolve, _ in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                resolve(100)
            }
        }
        var result: Int?
        promise.then { value in
            result = value
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(result, 100)
    }
}
