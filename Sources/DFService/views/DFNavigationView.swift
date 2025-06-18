//import SwiftUI
//
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//public struct DFNavigationView: View {
//    @Environment(\.navigation) var navigation
//    let routeBuilder: (DFNavigation.Destination) -> AnyView
//
//    public var body: some View {
//        if #available(iOS 16.0, *) {
//            NavigationStack(path: Binding(get: {
//                navigation.store.state.paths
//            }, set: { value in
//                navigation.store.dispatch(.setPath(value))
//            })) {
//                if let root = navigator.st {
//                    routeBuilder(root)
//                        .navigationDestination(for: DFNavigation.Destination.self) { destination in
//                            routeBuilder(destination)
//                        }
//                } else {
//                    Text("No Root Route")
//                }
//            }
//        } else {
//            // 旧版本兼容逻辑（参照前述嵌套 NavigationLink 模拟）
//        }
//    }
//}
