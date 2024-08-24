public struct ServiceName: RawRepresentable, Equatable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    public init(_ value: String) {
        self.rawValue = value
    }
    
    
    public static let logger = ServiceName("df.logger")
    public static let router = ServiceName("df.router")
}


extension ServiceName: DFApiCall {
    @discardableResult
    public func callAsFunction(_ context: ApiCallConext) async throws -> Any {
        
        guard let value = ServiceValues.shared.findBy(self) else {
            throw DFError.unImplemented()
        }
        return try await value.callAsFunction(context)
    }
}
