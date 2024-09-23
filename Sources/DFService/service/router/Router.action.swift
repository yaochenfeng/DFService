import SwiftUI
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
    public func handleAction(_ request: RouteRequest) {
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
        
        if let handler = customHandlerGo {
            return handler(request)
        }
        
    }
    func pop() {
        if  let path = presentingSheet {
            presentingSheet = nil
            if let handler = customHandlerPop {
                return handler(path)
            }
        } else if !pagePath.isEmpty {
            let path = pagePath.removeLast()
            if let handler = customHandlerPop {
                return handler(path)
            }
        }
    }
    func popToRoot() {
        if  presentingSheet != nil {
            presentingSheet = nil
        }
        pagePath.removeAll()
        
        if let handler = customHandlerPopRoot {
            return handler(.init(page: .root))
        }
    }
}
