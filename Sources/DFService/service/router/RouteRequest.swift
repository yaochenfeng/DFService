
public class RouteRequest: ObservableObject {
    public enum RouterType {
        case push
        case present
    }
    /// 路由操作
    public var routeAction: Router.RouteAction = .empty
    public let url: URL?
    /// 参数
    public var param: Any?
    public var routeType = RouterType.push
    public required init(url: URL) {
        self.url = url
        self.isHandle = false
    }
    public required init(action: Router.RouteAction, url: URL? = nil) {
        self.url = url
        self.routeAction = action
        self.isHandle = true
    }
    /// 是否需要经过router handler
    internal var isHandle: Bool = false
}


public extension RouteRequest {
    /// 跳转到指定页面
    convenience init(page: Router.RoutePath, url: URL? = nil){
        self.init(action: .page(page), url: url)
    }
    var routePath: Router.RoutePath {
        switch routeAction {
        case .page(let path):
            return path
        default:
            return .page404
        }
    }
    
    var copy: RouteRequest {
        let new = RouteRequest(action: routeAction, url: url)
        new.param = param
        return new
    }
}
public extension Router.RoutePath {
    var request: RouteRequest {
        return RouteRequest(page: self)
    }
}
extension RouteRequest: Hashable {
    public static func == (lhs: RouteRequest, rhs: RouteRequest) -> Bool {
        return lhs.routeAction == rhs.routeAction && lhs.url == rhs.url && ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(routePath)
        hasher.combine(routeAction)
    }
}
