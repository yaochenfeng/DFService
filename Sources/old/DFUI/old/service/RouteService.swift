import SwiftUI
public struct RouteService: DFServiceKey, EnvironmentKey {
    public static var defaultValue: Router {
        return Value.shared
    }
}

struct CurrentRequestKey: DFServiceKey, EnvironmentKey {
    public static var defaultValue: RouteRequest {
        return RouteRequest.init(action: .empty)
    }
}

public extension EnvironmentValues {
    var router: Router {
        get {
            self[RouteService.self]
        }
        set {
            self[RouteService.self] = newValue
        }
    }
    
    var routeRequest: RouteRequest {
        get {
            self[CurrentRequestKey.self]
        }
        set {
            self[CurrentRequestKey.self] = newValue
        }
    }
}

public extension Application {
    var router: Router {
        get {
            self[RouteService.self]
        }
        set {
            self[RouteService.self] = newValue
        }
    }
}
