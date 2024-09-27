import DFService
import SwiftUI
class RouteServiceProvider: ServiceProvider {
    
    override func register() {
        app[RouteService.self, SceneEnum.setting.rawValue] = Router()
        
        PageEnum.allCases.forEach { value in
            switch value {
                
            case .detail:
                Router.shared.addPage(value.routePath) { req in
                    PageLayout {
                        Text("Select an item")
                    }.pagBar(title: "标题")
                }
            case .demo:
                Router.shared.addPage(value.routePath) { req in
                    DemoPage()
                }
            case .web:
                Router.shared.addPage(value.routePath) { req in
                    WebPage(req.url?.absoluteString ?? "https://m.baidu.com")
                }
            }
        }
        
    }
    override func performAsyncStartup() async  throws {
        app[LogService.self].error("错误")
        if !app.state.agreePrivacy {
            app[RouteService.self].addPage(.root) { req in
                PrivacyPage()
            }
            
            throw CommonError.biz(code: 401, msg: "未同意")
        } else if !app.state.isLogin {
            app[RouteService.self].addPage(.root) { req in
                LoginPage()
            }
            throw CommonError.biz(code: 401, msg: "未同意")
        } else {
            app[RouteService.self].addPage(.root) { req in
                DemoPage()
            }
        }
        
    }
    override var when: ServiceProvider.ProviderWhen {
        return .eager
    }
    
    
    
    
    @ViewBuilder
    func buildRoot() -> some View {
        Text("root View")
            .padding()
    }
}


enum PageEnum: String, CaseIterable {
    case detail
    case demo
    case web
    
    var routePath: Router.RoutePath {
        return Router.RoutePath(rawValue: "page/\(rawValue)")
    }
    
    func go(router:Router = .shared,
            url: URL? = nil,
            routeType: RouteRequest.RouterType = .push) {
        let request = RouteRequest(page: routePath, url: url)
        request.routeType = routeType
        router.go(request)
    }
}
