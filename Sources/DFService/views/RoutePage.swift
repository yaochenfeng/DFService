//
//  SwiftUIView.swift
//  
//
//  Created by yaochenfeng on 2024/8/31.
//

import SwiftUI

public struct RoutePage: View {
    let request: RouteRequest
    public init(_ request: RouteRequest) {
        self.request = request
    }
    @Environment(\.router) var router
    public var body: some View {
        router.page(request)
    }
}

struct RoutePage_Previews: PreviewProvider {
    static var previews: some View {
        RoutePage(.init(page: .root))
    }
}
