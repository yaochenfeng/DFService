import Foundation
/// 常用错误定义
public enum DFError: Error {
    /// 业务错误
    case biz(code: Int, msg: String)
    /// 未实现
    case unImplemented(String = #function)
    /// 自定义错误
    case custom(Error)
    /// 未找到
    case notFound(Any = ())
    /// 转换失败
    case convert(from: String, to: String)
}
