import DFService
import SwiftUI
class RouteServiceProvider: ServiceProvider {
    
    override func performAsyncStartup() async throws {
        guard let app = app as? DemoApp else {
            return
        }
        app.rootView = AnyView(buildRoot())
    }
    override var when: ServiceProvider.ProviderWhen {
        return .window
    }
    
    
    @ViewBuilder
    func buildRoot() -> some View {
        Text("root View")
    }
}
