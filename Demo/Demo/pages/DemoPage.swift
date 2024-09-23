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
    }
}

struct DemoPage_Previews: PreviewProvider {
    static var previews: some View {
        DemoPage()
    }
}

extension Router.RoutePath {
    static let demo = Router.RoutePath(rawValue: "page/demo")
    static let web = Router.RoutePath(rawValue: "page/web")
}

extension RouteRequest: CaseIterable, Identifiable {
    public static var allCases: [DFService.RouteRequest] {
        [
            Router.RoutePath.root,
            .demo,
            .detail,
            .page404
        ]
            .map { path in
                return path.request
            }
    }

}
