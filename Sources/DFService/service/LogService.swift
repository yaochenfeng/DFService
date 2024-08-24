public protocol DFLogHandle {
    func debug(_ msg: String)
}

public struct LogService: DFApiService {
    public static var defaultValue: DFLogHandle {
        return MockApiServiceImpl()
    }
}

extension MockApiServiceImpl: DFLogHandle {
    func debug(_ msg: String) {
        debugPrint(msg)
    }
}
