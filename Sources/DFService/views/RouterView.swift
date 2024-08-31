import SwiftUI

public struct RouterView<T: View>: View {
    public init(rootView: T) {
        self.rootView = rootView
    }
    var rootView: T
    
    @EnvironmentObject var router: Router
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationStack(path: $router.pagePath) {
                rootView
                    .navigationDestination(for: RouteRequest.self) { arg in
                        router.page(arg)
                    }
                
                    .navigationDestination(isPresented: router.sheetBind) {
                        getSheetView()
                    }
            }
        } else {
            NavigationView {
                rootView
                    .sheet(isPresented: router.sheetBind) {
                        getSheetView()
                    }
                
                if let path = router.pagePath.last {
                    router.page(path)
                }
            }.chain { view in
                #if os(macOS)
                    view
                #else
                if #available(iOS 13.0, *) {
                    view.navigationViewStyle(.stack)
                } else {
                    view
                }
                #endif
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
       
        
        RouterView(rootView: Text("hello"))
    }
}
