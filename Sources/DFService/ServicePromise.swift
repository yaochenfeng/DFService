public final class ServicePromise<Value> {
    public typealias Resolve = (Value) -> Void
    public typealias Reject = (Error) -> Void
    public enum State {
        case pending, fulfilled, rejected, cancelled
    }

    private var successHandler: ((Value) -> Void)?
    private var failureHandler: ((Error) -> Void)?
    private var finalHandler: (() -> Void)?
    private var cancelHandler: (() -> Void)?

    private(set) public var state: State = .pending
    private var result: Result<Value, Error>?
    private var isResolved = false
    private var isCancelled = false

    public init(
        _ executor: @escaping (_ resolve: @escaping Resolve, _ reject: @escaping Reject) -> Void
    ) {
        executor(resolve, reject)
    }

    public func resolve(_ value: Value) {
        guard !isResolved && !isCancelled else { return }
        isResolved = true
        state = .fulfilled
        result = .success(value)
        successHandler?(value)
        finalHandler?()
    }

    public func reject(_ error: Error) {
        guard !isResolved && !isCancelled else { return }
        isResolved = true
        state = .rejected
        result = .failure(error)
        failureHandler?(error)
        finalHandler?()
    }

    @discardableResult
    public func then(_ handler: @escaping (Value) -> Void) -> Self {
        successHandler = handler
        if case .success(let value)? = result {
            handler(value)
        }
        return self
    }

    @discardableResult
    public func `catch`(_ handler: @escaping (Error) -> Void) -> Self {
        failureHandler = handler
        if case .failure(let error)? = result {
            handler(error)
        }
        return self
    }

    @discardableResult
    public func finally(_ handler: @escaping () -> Void) -> Self {
        finalHandler = handler
        if result != nil {
            handler()
        }
        return self
    }

    public func cancel() {
        guard !isResolved && !isCancelled else { return }
        isCancelled = true
        state = .cancelled
        cancelHandler?()
    }

    @discardableResult
    public func onCancel(_ handler: @escaping () -> Void) -> Self {
        cancelHandler = handler
        return self
    }
}

extension ServicePromise {

    /// 转换当前 Promise 的结果为新的值类型
    @discardableResult
    public func map<T>(_ transform: @escaping (Value) -> T) -> ServicePromise<T> {
        return ServicePromise<T> { resolve, reject in
            self.then { value in
                resolve(transform(value))
            }.catch { error in
                reject(error)
            }
        }
    }

    /// 扁平化嵌套 Promise，适合返回另一个异步任务
    @discardableResult
    public func flatMap<T>(_ transform: @escaping (Value) -> ServicePromise<T>) -> ServicePromise<T>
    {
        return ServicePromise<T> { resolve, reject in
            self.then { value in
                let next = transform(value)
                next.then(resolve).catch(reject)
            }.catch { error in
                reject(error)
            }
        }
    }

    /// 等待多个 Promise 完成，返回一个新的 Promise 包含所有结果
    public static func all<T>(_ promises: [ServicePromise<T>]) -> ServicePromise<[T]> {
        return ServicePromise<[T]> { resolve, reject in
            var results = [T?](repeating: nil, count: promises.count)
            var remaining = promises.count

            for (i, promise) in promises.enumerated() {
                promise.then { value in
                    results[i] = value
                    remaining -= 1
                    if remaining == 0 {
                        resolve(results.compactMap { $0 })
                    }
                }.catch(reject)
            }
        }
    }

    // 异步构造：从 async 函数创建 ServicePromise
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public static func fromAsync(_ work: @escaping () async throws -> Value) -> ServicePromise<
        Value
    > {
        return ServicePromise { resolve, reject in
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

    /// 将当前 ServicePromise 转换为异步函数，适用于 Swift 5.5+ 的 async/await
    /// 注意：此方法需要在支持 async/await 的环境中使用
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func toAsync() async throws -> Value {
        return try await withCheckedThrowingContinuation { continuation in
            self.then { value in
                continuation.resume(returning: value)
            }.catch { error in
                continuation.resume(throwing: error)
            }
        }
    }

}
