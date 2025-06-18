//
//  SwiftUIView.swift
//  client
//
//  Created by yaochenfeng on 2025/6/18.
//

import SwiftUI
import DFService

struct HomePage: View {
    @EnvironmentObject var store: ServiceStore<NavPathStack>
    var body: some View {
        List {
            // 添加路由测试
            Text("Hello, HomePage!")
            Button("跳转到详情页") {
                // TODO: 实现跳转到详情页
                store(.navigate(NavDestination(info: NavPathInfo(name: "/detail"), builder: { info in
                    DetailPage(itemId: info.param.value(at: "itemId")?.optional() ?? 2)
                })))
            }
            Button("跳转到设置页") {
                // TODO: 实现跳转到设置页
            }
            Button("跳转到登录页") {
                // TODO: 实现跳转到登录页
            }

        }.navigationTitle("首页")
    }
}

#Preview {
    HomePage()
}
