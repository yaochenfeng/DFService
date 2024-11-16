import Foundation


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public final class RouteService: ServiceKey, ServiceHandler, ObservableObject {
    public static var name: String = "router"
    
    public static let shared: RouteService = RouteService()
    public static var service: Service<RouteService> {
        return Service(shared, handler: shared)
    }
    required public init() {
        
    }
    public func callAsFunction(method: String, args: Any...) -> ServiceResult<Any, Error> {
        return .none
    }
}
