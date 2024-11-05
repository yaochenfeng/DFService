import Foundation
import SwiftUI

///// 定义服务实现
public protocol ServiceHandler {
    @discardableResult
    func callAsFunction(method: String, args: Any...) -> ServiceResult<Any, Error>
}
