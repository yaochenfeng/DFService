import DFService
import SwiftUI
class RouteServiceProvider: ServiceProvider {
    
    override func performAsyncStartup() async  throws {
//        app.rootView = AnyView(buildRoot())
        throw CommonError.unImplemented()
    }
    override var when: ServiceProvider.ProviderWhen {
        return .eager
    }
    
    
    @ViewBuilder
    func buildRoot() -> some View {
        Text("root View")
    }
}

extension Router.RoutePath {
    static let detail =  Router.RoutePath(rawValue: "page/detail")
}
