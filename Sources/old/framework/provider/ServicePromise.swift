import Foundation


public final class ServicePromise<Success, Failure> where Failure: Error {
    // 存储操作结果
    private var result: Result<Success, Failure>?
    // 存储回调（异步操作完成后触发）
    private var callbacks: [(Result<Success, Failure>) -> Void] = []
    
    // 初始化
    public init() {}
    
    // 完成 Promise（成功或失败）
    public func fulfill(with result: Result<Success, Failure>) {
        self.result = result
        // 调用所有等待的回调
        callbacks.forEach { $0(result) }
        callbacks.removeAll() // 清空回调
    }
    
    // 添加回调
    public func then(_ callback: @escaping (Result<Success, Failure>) -> Void) {
        if let result = self.result {
            // 如果已经完成，立即回调
            callback(result)
        } else {
            // 如果没有完成，保存回调
            callbacks.append(callback)
        }
    }
    
    // 异常处理
    public func `catch`(_ callback: @escaping (Failure) -> Void) {
        then { result in
            if case .failure(let error) = result {
                callback(error)
            }
        }
    }
    
    // 链式调用处理
    public func done(_ callback: @escaping (Success) -> Void) {
        then { result in
            if case .success(let value) = result {
                callback(value)
            }
        }
    }
}

#if canImport(Combine)
import Combine
public extension ServicePromise {
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func asFuture() -> Future<Success, Failure> {
        return Future { promise in
            self.then { result in
                switch result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    static func from(_ future: Future<Success, Failure>) -> ServicePromise<Success, Failure> {
        let promise = ServicePromise<Success, Failure>()
        _ = future.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break // 处理完成
            case .failure(let error):
                promise.fulfill(with: .failure(error))
            }
        }, receiveValue: { value in
            promise.fulfill(with: .success(value))
        })
        return promise
    }
}

#endif
