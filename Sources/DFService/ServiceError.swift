// 错误类型
/// Represents errors that can occur within the service layer.
///
/// - api: Indicates an API error with an associated error code and message.
/// - notImplemented: Indicates that a feature or method is not yet implemented. The default value includes the file and function name.

import Foundation

public enum ServiceError: Error {
    public static var invalidParameters = 1000
    /// API 错误，包含错误代码和消息
    /// - Parameters:
    ///   - code: 错误代码
    ///   - message: 错误消息
    ///   - detail: 可选的调试消息，默认为 nil
    case api(code: Int, message: String, detail: String? = nil)

    /// 转换类型失败
    case castError(from: Any, to: Any.Type)
    /// 未实现
    case notImplemented(String = #function)
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

/// 扩展 ServiceError 以提供错误描述
extension ServiceError: CustomStringConvertible {
    public var errorCode: Int {
        switch self {
        case .api(let code, _, _):
            return code
        default:
            return ServiceError.invalidParameters
        }
    }
    public var description: String {
        switch self {
        case .api(_, let message, _):
            return message
        case .notImplemented(let location):
            return "未实现: \(location)"
        case .custom(let error):
            return error.localizedDescription
        case .castError:
            return "参数错误"
        }
    }
}
