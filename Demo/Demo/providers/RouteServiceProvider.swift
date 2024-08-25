import DFService
import SwiftUI
class RouteServiceProvider: ServiceProvider {
    
    override func performAsyncStartup() async {
//        app.rootView = AnyView(buildRoot())
    }
    override var when: ServiceProvider.ProviderWhen {
        return .window
    }
    
    
    @ViewBuilder
    func buildRoot() -> some View {
        Text("root View")
    }
}

extension Router.RoutePath {
    static let detail =  Router.RoutePath(rawValue: "page/detail")
}
