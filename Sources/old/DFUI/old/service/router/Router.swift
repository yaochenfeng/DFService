import Foundation

public struct RouteSetting {
    let name: String?
    let arguments: Any
}

public class Router: ObservableObject {
    public enum RouteAction: Equatable, Hashable {
        case empty
        case page(Router.RoutePath)
        case action(Router.RoutePath)
    }
    
    public struct RoutePath: RawRepresentable, Equatable, Hashable {
        public static let page404 = RoutePath(rawValue: "page/404")
        public static let root = RoutePath(rawValue: "page/root")
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    typealias PageBuilder = (RouteRequest) -> PageRoute
    public typealias ActionBuilder = (RouteRequest) -> Void
    public static let shared = Router()
    /// 自定义go实现
    internal var customHandlerGo: ActionBuilder?
    internal var customHandlerPop: ActionBuilder?
    internal var customHandlerPopRoot: ActionBuilder?
    public var handler:(RouteRequest) -> RouteAction = { _ in
        return .empty
    }
    public var onGenerateRoute: (RoutePath) -> PageRoute = { setting in
        return PageRoute(
            builder: {
                DemoPage()
            },
            path: setting,
            routeType: .push)
    }
    
    public var page404: (RouteRequest) -> any View = { _ in
        return EmptyView()
    }
    @Published
    public var rootPath = RoutePath.root.request
    @Published
    public var pages = [PageRoute]()
    @Published
    public var pagePath = [RouteRequest]()
    @Published
    public var presentingSheet: RouteRequest?
    
    internal var pageBuilderMap = [RoutePath: PageBuilder]()
    internal var actionBuilderMap = [RoutePath: ActionBuilder]()
    public init() {}
    
    var sheetBind: Binding<Bool> {
        return .init {
            return self.presentingSheet != nil
        } set: { _ in
            self.presentingSheet = nil
        }

    }
    
    weak var controller: RouterNavigationController?

}

public extension Router {
    @discardableResult
    func addAction(_ path: RoutePath,
             @ViewBuilder
             builder:  @escaping (RouteRequest) -> Void) -> Router {
        actionBuilderMap[path] = builder
        return self
    }

}
