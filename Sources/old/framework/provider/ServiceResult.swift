import Foundation

public enum ServiceResult<Success, Failure> where Failure : Error {
    /// 同步结果
    case sync(Result<Success, Failure>)
    /// 异步结果
    case promise(ServicePromise<Success, Failure>)
    /// 无需返回结果
    case none
}
