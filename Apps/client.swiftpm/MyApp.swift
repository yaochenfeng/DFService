import SwiftUI
import DFService

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


enum PageRoute: String {
    case home
    case setting
}
extension PageRoute: View {
    var body: some View {
        Group {
            switch self {
            case .home:
                Text("home")
            case .setting:
                Text("setting")
            }
        }
    }
    
}


class HomeModule: DFModuleType {
    required init() {
        
    }
    func canHandleRoute(_ context: DFService.DFRouter.RouteSetting) -> Bool {
        return true
    }
    
    func resolveRoute(_ context: DFService.DFRouter.RouteSetting) -> Any? {
       
        return AnyView(PageRoute(rawValue: context.route) ?? .home)
        
    }
    
    
}
