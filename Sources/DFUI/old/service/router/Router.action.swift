import SwiftUI
extension Router {
    
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
        if request.routeAction == .page(.root) {
            popToRoot()
            return
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
        _ = self.pages.popLast()
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
    
    func canPop() -> Bool {
        if  let _ = presentingSheet {
            return true
        } else if !pagePath.isEmpty {
            return true
        }
        return false
    }
}
