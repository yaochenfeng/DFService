import SwiftUI

public struct RouterView: View {
    public init(router: Router = .shared) {
        self._router = .init(wrappedValue: router)
    }
    
    @StateObject var router: Router
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationStack(path: $router.pagePath) {
                router.page(router.rootPath)
                
                    .navigationDestination(for: RouteRequest.self) { arg in
                        router.page(arg)
                    }
                
                    .navigationDestination(isPresented: router.sheetBind) {
                        getSheetView()
                    }
            }
        } else {
            NavigationView {
                router.page(router.rootPath)
                    .sheet(isPresented: router.sheetBind) {
                        getSheetView()
                    }
                
                if let path = router.pagePath.last {
                    router.page(path)
                }
            }.chain { view in
                if #unavailable(macOS 10) {
                    view.navigationViewStyle(.stack)
                } else {
                    view
                }
            }
        }
    }
    
    @ViewBuilder
    func getSheetView() -> some View {
        
        if let state = router.presentingSheet {
            router.page(state)
        } else {
            EmptyView()
        }
    }
}

struct RouteNavigationViewPreview: PreviewProvider {
    static var previews: some View {
        RouterView()
    }
}
