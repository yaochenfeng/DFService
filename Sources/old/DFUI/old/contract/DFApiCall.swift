public class ApiCallConext {
    let method: String
    let param: Codable
    public var options = [String: Any]()
    
    public init(method: String, param: Codable) {
        self.method = method
        self.param = param
    }
}

/// api调用
public protocol DFApiCall {
    /// 提供异步调用
    func callAsFunction( _ context: ApiCallConext) async throws -> Any
}
