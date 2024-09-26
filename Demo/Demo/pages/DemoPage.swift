//
//  DemoPage.swift
//  Demo
//
//  Created by yaochenfeng on 2024/9/21.
//

import DFService

struct DemoPage: View {
    @Environment(\.router)
    var router
    var body: some View {
        PageLayout {
            List {
                ForEach(RouteRequest.allCases) { req in
                    Text("\(req.routePath.rawValue)").onTapGesture {
                        router.go(req)
                    }
                }
                Text("返回").onTapGesture {
                    router.pop()
                }
                Text("返回首页").onTapGesture {
                    router.popToRoot()
                }
            }
        }.pagBar {
            PageBar("demo")
        }
    }
}

struct DemoPage_Previews: PreviewProvider {
    static var previews: some View {
        DemoPage()
    }
}

extension RouteRequest: CaseIterable, Identifiable {
    public static var allCases: [DFService.RouteRequest] {
        [
            Router.RoutePath.root
        ]
            .map { path in
                return path.request
            }
        
        + PageEnum.allCases.map({ value in
            return value.routePath.request
        })
    }

}
