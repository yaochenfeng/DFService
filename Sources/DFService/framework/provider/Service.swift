public struct Service<Base> {
    public let base: Base
    private let provider: ServiceFactory
    public init(_ base: Base, provider: ServiceFactory) {
        self.base = base
        self.provider = provider
    }
}

extension Service where Base: ServiceKey {
    @discardableResult
    public func callAsFunction(method: String, args: Any...) -> ServiceResult<Any, Error> {
        return provider(name: Base.name, method: method, args: args)
    }
}
