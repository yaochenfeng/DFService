//
//  SwiftUIView.swift
//  
//
//  Created by yaochenfeng on 2024/11/15.
//

import SwiftUI

public struct PageRoute: View {
    let page: AnyView
    let path: Router.RoutePath
    var routeType: RouteRequest.RouterType
    public init<T: View>(
        @ViewBuilder builder: () -> T,
        path: Router.RoutePath,
        routeType: RouteRequest.RouterType
    ) {
        self.page = AnyView(builder())
        self.path = path
        self.routeType = routeType
    }
    public var body: some View {
        page
    }
}

extension PageRoute: Hashable {
    public static func == (lhs: PageRoute, rhs: PageRoute) -> Bool {
        lhs.path == rhs.path
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }
    
}
