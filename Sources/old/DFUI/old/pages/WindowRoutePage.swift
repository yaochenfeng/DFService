//
//  SwiftUIView.swift
//  
//
//  Created by yaochenfeng on 2024/11/14.
//

import SwiftUI

struct WindowRoutePage: View {
    @StateObject
    var router: Router = .shared
    var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationStack(path: pushBind ) {
                router.page(.init(page: .root))
            }

        }
    }
    
//    lazy var pushBind = Binding {
//        return router.pages.filter { item in
//            return item.routeType == .push
//        }
//    } set: { newValue, _ in
//
//    }
    
    var pushBind: Binding<[PageRoute]> {
        return Binding {
            return router.pages.filter { item in
                return item.routeType == .push
            }
        } set: { newValue, _ in
            
        }
    }
    
    var presentBind: Binding<[PageRoute]> {
        return Binding {
            let pages = router.pages.filter { item in
                return item.routeType == .present
            }
            return pages
        } set: { newValue, _ in
            print("set newValue\(newValue)" )
        }
    }
    
    var isPresented: Binding<Bool> {
        return Binding {
            let result =
             router.pages.contains { page in
                return page.routeType == .present
            }
            return result
        } set: { newValue, _ in
            print("set newValue\(newValue)" )
        }

    }

    struct Stack: View {
        let pageBind: Binding<[PageRoute]>
        var body: some View {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                NavigationStack(path: pathBind) {
                    if let page = pageBind.wrappedValue.first {
                        page
                            .navigationDestination(for: PageRoute.self) { page in
                                                page
                            }
                    } else {
                        EmptyView()
                    }
                }
            }
        }
        var pathBind: Binding<[PageRoute]>  {
            return Binding {
                var pages = pageBind.wrappedValue
                _ = pages.removeFirst()
                return pages
            } set: { newValue, _ in
                
            }

        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = Router.shared.addPage(.root) { req in
            Text("req\(req.routePath.rawValue)")
            DemoPage()
        }
        WindowRoutePage()
    }
}

struct DemoPage: View {
    var body: some View {
        VStack {
            Button("push") {
                Router.shared.go(RouteRequest(page: .init(rawValue: "push")))
            }
            Button("present") {
                let req = RouteRequest(page: .init(rawValue: "present"))
                req.routeType = .present
                Router.shared.go(req)
            }
        }
    }
}
