public final class ServicePromise<Value> {
    public typealias Resolve = (Value) -> Void
    public typealias Reject = (Error) -> Void
    public enum State {
        case pending, fulfilled, rejected
    }

    // private var successHandler: ((Value) -> Void)?
    // private var failureHandler: ((Error) -> Void)?
    // private var finalHandler: (() -> Void)?
    // private var cancelHandler: (() -> Void)?
    /// 用于存储成功回调的数组，便于在 Promise 被解析时调用
    private var onSuccessHandlers: [(Value) -> Void] = []
    /// 用于存储失败回调的数组，便于在 Promise 被拒绝时调用
    private var onFailureHandlers: [(Error) -> Void] = []
    /// 用于存储最终回调的数组，便于在 Promise 完成时调用
    private var onFinallyHandlers: [() -> Void] = []

    public private(set) var state: State = .pending
    public private(set) var result: Result<Value, Error>?

    public init(
        _ executor: @escaping (_ resolve: @escaping Resolve, _ reject: @escaping Reject) -> Void
    ) {
        executor(resolve, reject)
    }

    public func resolve(_ value: Value) {
        guard state == .pending else { return }
        state = .fulfilled
        result = .success(value)
        self.onSuccessHandlers.forEach { $0(value) }
        self.onFinallyHandlers.forEach { $0() }
        clearCallbacks()
    }

    public func reject(_ error: Error) {
        guard state == .pending else { return }
        state = .rejected
        result = .failure(error)
        self.onFailureHandlers.forEach { $0(error) }
        self.onFinallyHandlers.forEach { $0() }
        clearCallbacks()
    }

    private func clearCallbacks() {
        onSuccessHandlers.removeAll()
        onFailureHandlers.removeAll()
        onFinallyHandlers.removeAll()
    }
}

extension ServicePromise {
    @discardableResult
    public func then<U>(_ onFulfilled: @escaping (Value) throws -> U) -> ServicePromise<U> {
        return ServicePromise<U> { resolve, reject in
            let handle = { (value: Value) in
                do {
                    let result = try onFulfilled(value)
                    resolve(result)
                } catch {
                    reject(error)
                }
            }

            switch self.state {
            case .fulfilled:
                if case .success(let value) = self.result {
                    handle(value)
                }
            case .rejected:
                if case .failure(let error) = self.result {
                    reject(error)
                }
            case .pending:
                self.onSuccessHandlers.append(handle)
                self.onFailureHandlers.append(reject)
            }
        }
    }
    @discardableResult
    public func then<U>(
        _ onFulfilled: @escaping (Value) throws -> ServicePromise<U>
    ) -> ServicePromise<U> {
        return ServicePromise<U> { resolve, reject in
            let handle: (Value) -> Void = { value in
                do {
                    let nextPromise = try onFulfilled(value)
                    nextPromise.then { innerValue in
                        resolve(innerValue)
                    }.catch { error in
                        reject(error)
                    }
                } catch {
                    reject(error)
                }
            }

            switch self.state {
            case .fulfilled:
                if case .success(let value) = self.result {
                    handle(value)
                }
            case .rejected:
                if case .failure(let error) = self.result {
                    reject(error)
                }
            case .pending:
                self.onSuccessHandlers.append(handle)
                self.onFailureHandlers.append(reject)
            }
        }
    }

    @discardableResult
    public func `catch`(_ onRejected: @escaping (Error) -> Void) -> Self {
        switch self.state {
        case .fulfilled:
            break
        case .rejected:
            if case .failure(let error) = self.result {
                onRejected(error)
            }
        case .pending:
            self.onFailureHandlers.append(onRejected)
        }
        return self
    }
    @discardableResult
    public func finally(_ onFinally: @escaping () -> Void) -> Self {
        switch self.state {
        case .fulfilled, .rejected:
            onFinally()
        case .pending:
            self.onFinallyHandlers.append(onFinally)
        }
        return self
    }

    //拓展Promise 常用函数 转换错误等
    public static func all(_ promises: [ServicePromise<Value>]) -> ServicePromise<[Value]> {
    return ServicePromise<[Value]> { resolve, reject in
        var results = Array<Value?>(repeating: nil, count: promises.count)
        var remaining = promises.count

        if promises.isEmpty {
            resolve([])
            return
        }

        for (index, promise) in promises.enumerated() {
            promise.then { value in
                results[index] = value
                remaining -= 1
                if remaining == 0 {
                    // 全部 fulfilled 后，转换为 [Value]
                    resolve(results.compactMap { $0 })
                }
            }.catch { error in
                // 任何一个失败，立即 reject
                reject(error)
            }
        }
    }
}

    public static func resolve(_ value: Value) -> ServicePromise<Value> {
        return ServicePromise<Value> { resolve, _ in
            resolve(value)
        }
    }

    public static func reject(_ error: Error) -> ServicePromise<Value> {
        return ServicePromise<Value> { _, reject in
            reject(error)
        }
    }

    public var value: Value? {
        switch self.result {
        case .success(let value):
            return value
        case .failure:
            return nil
        case nil:
            return nil
        }
    }

    public var isPending: Bool {
        return self.state == .pending
    }

}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension ServicePromise {
    public convenience init(
        _ work: @escaping () async throws -> Value
    ) {
        self.init { resolve, reject in
            Task {
                do {
                    let result = try await work()
                    resolve(result)
                } catch {
                    reject(error)
                }
            }
        }
    }
    public func wait() async throws -> Value {
        return try await withCheckedThrowingContinuation { continuation in
            self.then { value in
                continuation.resume(returning: value)
            }.catch { error in
                continuation.resume(throwing: error)
            }
        }
    }
}
