//
//  WindowRouteContent.swift
//  
//
//  Created by yaochenfeng on 2024/11/17.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
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
            .environmentObject(router)
        } else {
            NavigationView {
                router.page(router.initRoute)
                
                ZStack {
                    ForEach(router.pages) { page in
                        page
                    }
                }
                
            }.environmentObject(router)
        }
        
    }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct WindowRouteContent_Previews: PreviewProvider {
    static var previews: some View {
        WindowRouteContent()
    }
}
