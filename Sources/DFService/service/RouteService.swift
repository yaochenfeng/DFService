public struct RouteService: DFApiService {
    public static var defaultValue: Router {
        return Value.shared
    }
}

import SwiftUI

public class Router: ObservableObject {
    typealias PageBuilder = (RouteRequest) -> any View
    public static let shared = Router()
    
    public var handler:(RouteRequest) -> PagePath = { _ in
        return .page404
    }
    
    public var page404: (RouteRequest) -> any View = { _ in
        return EmptyView()
    }
    @Published
    public var rootPath = PagePath.root.request
    
    @Published
    public var pagePath = [RouteRequest]()
    @Published
    public var presentingSheet: RouteRequest?
    
    private var pageBuilderMap = [PagePath: PageBuilder]()
    public init() {}
    
    var sheetBind: Binding<Bool> {
        return .init {
            return self.presentingSheet != nil
        } set: { _ in
            self.presentingSheet = nil
        }

    }
}

public extension Router {
    func add(pid: PagePath,
             @ViewBuilder
             builder:  @escaping (RouteRequest) -> some View) {
        pageBuilderMap[pid] = builder
    }
    func page(_ request: RouteRequest) -> AnyView {
        if(!request.isHandle) {
            request.routePath = handler(request)
            request.isHandle = true
        }
        let pid = request.routePath
        guard let builder = pageBuilderMap[pid] else {
            return AnyView(page404(request))
        }
        return AnyView(builder(request))
    }
    
    
}
public extension Router {
    func go(_ request: RouteRequest) {
        if !request.isHandle {
            request.routePath = handler(request)
            request.isHandle = true
        }
        if(request.routePath == .root) {
            popToRoot()
            self.rootPath = request
            return
        }
        switch request.routeType {
        case .push:
            pagePath.append(request)
        case .present:
            presentingSheet = request
        }
    }
    func pop() {
        if  presentingSheet != nil {
            presentingSheet = nil
        } else if !pagePath.isEmpty {
            pagePath.removeLast()
        }
    }
    func popToRoot() {
        if  presentingSheet != nil {
            presentingSheet = nil
        }
        pagePath.removeAll()
    }
}


extension Router {
    public struct PagePath: RawRepresentable, Equatable, Hashable {
        public static let page404 = PagePath(rawValue: "page/404")
        public static let root = PagePath(rawValue: "page/root")
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public var request: RouteRequest {
            return RouteRequest(self)
        }
    }
}

extension EnvironmentValues {
    var pageRouter: Router {
        return serviceValues[RouteService.self]
    }
}

public class RouteRequest: ObservableObject {
    
    public let url: URL?
    public var options = [String: Any]()
    public var routeType = RouterType.push
    public init(_ url: URL) {
        self.url = url
        self.isHandle = false
    }
    public init(_ routePath: Router.PagePath) {
        self.url = nil
        self.routePath = routePath
        self.isHandle = true
    }
    /// 是否需要经过router handler
    internal var isHandle: Bool = false
    var routePath: Router.PagePath = .page404
}

extension RouteRequest: Hashable {
    public static func == (lhs: RouteRequest, rhs: RouteRequest) -> Bool {
        return lhs.routePath == rhs.routePath && lhs.url == rhs.url
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(routePath)
    }
}

public extension RouteRequest {
    enum RouterType {
        case push
        case present
    }
}
