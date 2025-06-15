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
    ///   - detail: 可选的调试消息，默认为 nil
    case api(code: Int, message: String, detail: String? = nil)

    /// 未实现
    case notImplemented(String = #fileID + " " + #function)
    /// 自定义错误
    case custom(Error)

    public static func from(_ error: Error) -> ServiceError {
        if let serviceError = error as? ServiceError {
            return serviceError
        } else {
            return .custom(error)
        }
    }
}
