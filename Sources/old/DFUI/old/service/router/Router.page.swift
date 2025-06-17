extension Router {
    @discardableResult
    public func addPage<T: View>(_ path: RoutePath,
                 @ViewBuilder
                 builder:  @escaping (RouteRequest) -> T) -> Router {
        pageBuilderMap[path] = { req in
            return PageRoute(builder: {
                builder(req)
            }, path: req.routePath , routeType: .push)
        }
        if path == .root {
            Thread.app.mainTask {
                self.rootPath = self.rootPath.copy
            }
        }
        return self
    }
    
    public func page(_ request: RouteRequest) -> PageRoute {
        if(!request.isHandle) {
            request.routeAction = handler(request)
            request.isHandle = true
        }
        let pid = request.routePath
        guard let builder = pageBuilderMap[pid] else {
            return onGenerateRoute(pid)
        }
        return PageRoute(builder: {
            return builder(request)
        }, path: pid,
                         routeType: request.routeType)
    }
    
    internal func handlePage(_ request: RouteRequest) {
        var route = self.page(request)
        route.routeType = request.routeType
        pages.append(route)
        switch request.routeType {
        case .push:
            pagePath.append(request)
        case .present:
            presentingSheet = request
        }
    }
}
