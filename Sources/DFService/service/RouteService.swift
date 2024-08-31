import SwiftUI
public struct RouteService: DFServiceKey, EnvironmentKey {
    public static var defaultValue: Router {
        return Value.shared
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
}
