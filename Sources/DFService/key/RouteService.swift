import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public final class RouteService: ServiceKey, ServiceHandler, ObservableObject {
    public static var name: String = "router"
    
    public static let shared: RouteService = RouteService()
    public static var service: Service<RouteService> {
        return Service(shared, handler: shared)
    }
    required public init() {}
    public func callAsFunction(method: String, args: Any...) -> ServiceResult<Any, Error> {
        return .none
    }
    
    @Published
    public var initRoute = RouteSetting(name: "/", argument: ())
    
    @Published
    public var pages = [PageRoute]()
    
    internal var pageBuilderMap = [String: PageBuilder]()
    public var onGenerateRoute: (RouteSetting) -> PageRoute = { setting in
        return PageRoute(
            builder: {
                ScaffoldView {
                    Text("\(setting.name) 4o4")
                }
            },
            setting: setting)
    }
    
    internal var navigation: iOSNavigationController =  iOSNavigationController()
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension RouteService {
    public typealias PageBuilder = (RouteSetting) -> PageRoute
    
    public func contains(_ name: String) -> Bool {
        return pageBuilderMap.keys.contains(name)
    }
    public func page(_ setting: RouteSetting) -> PageRoute {
        guard let builder = pageBuilderMap[setting.name] else {
            return onGenerateRoute(setting)
        }
        return builder(setting)
    }
    @discardableResult
    public func addPage<T: View>(_ name: String,
                 @ViewBuilder
                 builder:  @escaping (RouteSetting) -> T) -> Self {
        pageBuilderMap[name] = { arg in
            return PageRoute(builder: {
                builder(arg)
            }, setting: arg)
        }
        return self
    }
    @discardableResult
    @MainActor
    public func push(_ setting: RouteSetting, animated: Bool = true) -> Self {
        if navigation.push(setting, animated: animated) {
            return self
        }
        let page = page(setting)
    
        self.pages.append(page)
        return self
    }
    
    @discardableResult
    @MainActor
    public func pop(_ setting: RouteSetting? = nil, animated: Bool = true) -> Self {
        if navigation.pop(setting, animated: animated) {
            return self
        }
        if let setting = setting, let idx = pages.firstIndex(where: { item in
            return item.setting.name == setting.name
        }) {
            self.pages = Array(self.pages.prefix(idx + 1))
        } else {
            _ = self.pages.popLast()
        }
        return self
    }
}

public struct RouteSetting {
    let name: String
    let argument: Any
    
    public init(name: String, argument: Any = ()) {
        self.name = name
        self.argument = argument
    }
}
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension EnvironmentValues {
    struct RouteKey: EnvironmentKey {
        static var defaultValue = RouteService.shared
    }
    public var router: RouteService {
        get {
            return self[RouteKey.self]
        }
        set {
            self[RouteKey.self] = newValue
        }
    }
}
