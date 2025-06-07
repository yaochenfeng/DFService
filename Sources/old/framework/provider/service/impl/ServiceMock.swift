import Foundation

struct ServiceMockHandler: ServiceHandler {
    
    func callAsFunction(method: String, args: Any...) -> ServiceResult<Any, Error> {
        print("mock: \(name) method: \(method), args:\(args)")
        return .none
    }
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
}
