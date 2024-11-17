//
//  WindowRouteContent.swift
//  
//
//  Created by yaochenfeng on 2024/11/17.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct WindowRouteContent: View {
    @StateObject
    var router = RouteService.shared
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationStack(path: $router.pages) {
                router.page(router.initRoute)
                    .navigationDestination(for: PageRoute.self) { page in
                        page
                    }
            }
            .environment(\.router, router)
        } else if Constant.isUIKit {
            iOSNavigationView()
                .ignoresSafeArea()
                .environment(\.router, router)
        } else {
            NavigationView {
                router.page(router.initRoute)
                
                ZStack {
                    ForEach(router.pages) { page in
                        page
                    }
                }
                
            }.environment(\.router, router)
        }
        
    }
}
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct WindowRouteContent_Previews: PreviewProvider {
    static var previews: some View {
        WindowRouteContent()
    }
}
