extension Router {
    @discardableResult
    public func addPage(_ path: RoutePath,
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
    
    public func page(_ request: RouteRequest) -> AnyView {
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
    
    internal func handlePage(_ request: RouteRequest) {
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
}
