public struct Service<Base> {
    public let base: Base
    private let handler: ServiceHandler
    public init(_ base: Base, handler: ServiceHandler) {
        self.base = base
        self.handler = handler
    }
}

extension Service where Base: ServiceKey {
    @discardableResult
    public func callAsFunction(method: String, args: Any...) -> ServiceResult<Any, Error> {
        return handler(method: method, args: args)
    }
}
