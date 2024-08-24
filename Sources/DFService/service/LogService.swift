public protocol DFLogHandle {
    func debug(_ msg: String)
}

public struct LogService: DFApiService {
    public static let serviceName: ServiceName = .logger
    
    public static var defaultValue: DFLogHandle {
        return MockApiService()
    }
}

extension MockApiService: DFLogHandle {
    func debug(_ msg: String) {
        debugPrint(msg)
    }
}
