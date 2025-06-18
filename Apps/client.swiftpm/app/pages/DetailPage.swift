//
//  DetailPage.swift
//  client
//
//  Created by yaochenfeng on 2025/6/18.
//

import SwiftUI
import DFService

struct DetailPage: View {
    @EnvironmentObject var store: ServiceStore<NavPathStack>
    let itemId: Int
    var body: some View {
//
        List {
            Text("详情页面:\(itemId)")
            Button("跳转到详情页") {
                // TODO: 实现跳转到详情页
                store(.navigate(NavDestination(info: NavPathInfo(name: "/detail"), builder: { info in
                    DetailPage(itemId: itemId + 1)
                })))
            }
            
            Button("返回") {
                store(.back)
            }
            
            Button("返回首页") {
                store(.backToRoot)
            }
            Button("设置当前为首页") {
                store(.setRoot(store.state.current))
            }
        }.navigationTitle("详情页面:\(itemId)")
        
    }
}

#Preview {
    DetailPage(itemId: 1)
}
