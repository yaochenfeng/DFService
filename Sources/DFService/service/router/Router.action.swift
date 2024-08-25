extension Router {
    fileprivate func handlePage(_ request: RouteRequest) {
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
    fileprivate func handleAction(_ request: RouteRequest) {
        guard let builder = self.actionBuilderMap[request.routePath] else {
            return
        }
        builder(request)
    }
}
public extension Router {
    func go(_ request: RouteRequest) {
        if !request.isHandle {
            request.routeAction = handler(request)
            request.isHandle = true
        }
        switch request.routeAction {
        case .empty: break
        case .page:
            handlePage(request)
        case .action:
            handleAction(request)
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
