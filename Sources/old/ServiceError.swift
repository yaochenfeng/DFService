import Foundation

/**
 * 服务错误枚举
 */
public enum ServiceError: Error {
    /// 转换失败
    case castFailed(expectedType: Any.Type, actualValue: Any)
    
    /// 未实现的功能
    case notImplemented(method: String = #function)
    
    /// 业务逻辑错误
    case businessError(code: Int, message: String)
}
