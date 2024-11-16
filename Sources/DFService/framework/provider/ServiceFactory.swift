/// 服务提供者
final class ServiceFactory {
    public static var shared = ServiceFactory()
    var storage: [String: ServiceHandler] = [:]
    var interceptor: ServiceInterceptor
    public init(_ interceptor: ServiceInterceptor = ServiceInterceptor()) {
        self.interceptor = interceptor
    }
}



extension ServiceFactory {
    public subscript(name: String) -> ServiceHandler {
        get {
            let key = name
            if let value = storage[key] {
                return value
            }
            return ServiceMockHandler(name: name)
        }
        set {
            let key = name
            storage[key] = newValue
        }
    }
    func callAsFunction(name: String, method: String, args: Any...) -> ServiceResult<Any, Error> {
        let hander = self[name]
        let arguments = Array(args)
        let next = {
            return hander.callAsFunction(method: method, args: args)
        }
        let context = ServiceInterceptor.Context(name: name, method: method, args: arguments)
        guard interceptor.canHandle(context) else {
            return next()
        }
        
        return interceptor.intercept(context: context, next: next)
    }
}
