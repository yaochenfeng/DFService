import DFService
import SwiftUI
class RouteServiceProvider: ServiceProvider {
    
    override func register() {
        app[RouteService.self, SceneEnum.setting.rawValue] = Router()
        app[RouteService.self, SceneEnum.setting.rawValue].addPage(.root) { req in
                self.buildRoot()
            
        }
    }
    override func performAsyncStartup() async  throws {
//        app.rootView = AnyView(buildRoot())
//        throw CommonError.unImplemented()
        app[LogService.self].error("错误")
        
       
        if !app.state.agreePrivacy {
            await MainActor.run {
                app[RouteService.self].addPage(.root) { req in
                    NavigationPage {
                        PrivacyPage()
                    }
                }
             }
        
            throw CommonError.biz(code: 401, msg: "未同意")
        } else if !app.state.isLogin {
            app[RouteService.self].addPage(.root) { req in
                LoginPage()
            }
            throw CommonError.biz(code: 401, msg: "未同意")
        } else {
           await MainActor.run {
                app[RouteService.self].addPage(.root) { req in
                    NavigationPage {
                        DemoPage()
                    }
                }
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

extension Router.RoutePath {
    static let detail =  Router.RoutePath(rawValue: "page/detail")
}
