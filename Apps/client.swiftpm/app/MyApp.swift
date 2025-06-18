import SwiftUI
import DFService


@main
struct MyApp: App {
    let context = DFAppContext.shared
    var body: some Scene {
        WindowGroup {
            DFNavigationView { info in
                HomePage()
            }
            
        }
    }
}
