
import Foundation

/// 服务拦截器，暂不实现
public struct ServiceInterceptor {
    public class Context {
        public let name: String
        public let method: String
        public let args: [Any]
        public var options: [String: Any]
        init(name: String, method: String, args: [Any], options: [String : Any] = [:]) {
            self.name = name
            self.method = method
            self.args = args
            self.options = options
        }
    }
    
    public init(
        canHandle:((Context) -> Bool)? = nil,
        before: ((Context) -> Void)? = nil,
        after: ((Context, ServiceResult<Any, Error>) -> Void)? = nil,
        around: ((Context) -> ServiceResult<Any, Error>)? = nil
    ) {
        self.canHandle = canHandle ?? { _ in return false }
        self.beforeAdvice = before
        self.afterAdvice = after
        self.aroundAdvice = around
    }
    var canHandle: (Context) -> Bool
    var beforeAdvice: ((Context) -> Void)?
    var afterAdvice: ((Context, ServiceResult<Any, Error>) -> Void)?
    var aroundAdvice: ((Context) -> ServiceResult<Any, Error>)?
    public func intercept(context: Context, next: () -> ServiceResult<Any, Error>) -> ServiceResult<Any, Error> {
        // Before advice
        beforeAdvice?(context)
        
        // Around advice, if provided, bypasses the actual method
        if let aroundAdvice = aroundAdvice {
            let result = aroundAdvice(context)
            afterAdvice?(context, result)
            return result
        }
        
        // Call the original method if there's no around advice
        let result = next()
        
        // After advice
        afterAdvice?(context, result)
        
        return result
    }
}
