// 错误类型
/// Represents errors that can occur within the service layer.
///
/// - api: Indicates an API error with an associated error code and message.
/// - notImplemented: Indicates that a feature or method is not yet implemented. The default value includes the file and function name.
public enum ServiceError: Error {
    /// API 错误，包含错误代码和消息
    /// - Parameters:
    ///   - code: 错误代码
    ///   - message: 错误消息
    ///   - debugMessage: 可选的调试消息，默认为 nil
    /// - Example: `ServiceError.api(code: 404, message: "Not Found")`
    /// - Example: `ServiceError.api(code: 500, message: "Internal Server Error", debugMessage: "Database connection failed")`
    case api(code: Int, message: String, debugMessage: String? = nil)

    /// 未实现
    case notImplemented(String = #fileID + " " + #function)
    /// 转换类型失败
    case castError(from: Any, to: Any.Type)
}
