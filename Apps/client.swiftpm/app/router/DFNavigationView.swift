
import SwiftUI
import DFService

public struct DFNavigationView: View {
    
    @ObservedObject var store: ServiceStore<NavPathStack>
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *){
            NavigationStack(path: pathBind) {
                store.state.root
                    .environmentObject(store)
                    .navigationDestination(for: NavDestination.self) { destination in
                        destination
                            .environmentObject(store)
                    }
            }
        } else {
            NavigationView {
                store.state.root
            }
        }
       
    }
    
    var pathBind: Binding<[NavDestination]> {
        return .init {
            return store.state.paths
        } set: { value in
            store.dispatch(.setPath(value))
        }

    }
    public init<Page:View>(name: String = "/", @ViewBuilder builder: (NavPathInfo) -> Page) {
        let root = NavDestination(info: NavPathInfo(name: name), builder: builder)
        self.store = ServiceStore(state: NavPathStack(root: root))
    }
}
