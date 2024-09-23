import Foundation

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
    
    typealias PageBuilder = (RouteRequest) -> any View
    public typealias ActionBuilder = (RouteRequest) -> Void
    public static let shared = Router()
    /// 自定义go实现
    public var customHandlerGo: ActionBuilder?
    public var customHandlerPop: ActionBuilder?
    public var customHandlerPopRoot: ActionBuilder?
    public var handler:(RouteRequest) -> RouteAction = { _ in
        return .empty
    }
    
    public var page404: (RouteRequest) -> any View = { _ in
        return EmptyView()
    }
    @Published
    public var rootPath = RoutePath.root.request
    
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
    
    weak var controller: RouterController?
}

public extension Router {
    @discardableResult
    func addPage(_ path: RoutePath,
             @ViewBuilder
             builder:  @escaping (RouteRequest) -> some View) -> Router {
        pageBuilderMap[path] = builder
        if path == .root {
            Thread.app.mainTask {
                self.rootPath = self.rootPath.copy
            }
            
        }
        return self
    }
    @discardableResult
    func addAction(_ path: RoutePath,
             @ViewBuilder
             builder:  @escaping (RouteRequest) -> Void) -> Router {
        actionBuilderMap[path] = builder
        return self
    }
    func page(_ request: RouteRequest) -> AnyView {
        if(!request.isHandle) {
            request.routeAction = handler(request)
            request.isHandle = true
        }
        let pid = request.routePath
        guard let builder = pageBuilderMap[pid] else {
            return AnyView(
                page404(request)
            )
        }
        return AnyView(
            builder(request)
        )
    }
}
