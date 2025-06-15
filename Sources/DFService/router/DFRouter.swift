public final class DFRouter {
    private var resultHandlers: [UUID: (Any?) -> Void] = [:]
    let context: DFAppContext
    let initRoute: RouteSetting
    public init(context: DFAppContext, initRoute: RouteSetting) {
        self.context = context
        self.initRoute = initRoute
    }
    var paths: [DFRouter.RouteSetting] = [] {
        didSet {
            // 这里可以添加路径更新的逻辑
            // 比如通知观察者，或者更新 UI 等
            #if canImport(SwiftUI)
                if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
                    notifyPathChange()
                }
            #endif
        }
    }
}

extension DFRouter {
    public struct RouteSetting: Hashable {
        let id = UUID()
        public let route: String
        public let parameters: [String: Any]
        public init(route: String, parameters: [String: Any] = [:]) {
            self.route = route
            self.parameters = parameters
        }
        public static func == (lhs: RouteSetting, rhs: RouteSetting) -> Bool {
            lhs.id == rhs.id
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

    }

    /// 导航到指定的模块
    public func navigate(_ context: RouteSetting, onResult: ((Any?) -> Void)? = nil) {
        if let onResult = onResult {
            resultHandlers[context.id] = onResult
        }
        paths.append(context)
    }

    public func pop(result: Any? = nil) {
        if let last = paths.last, let handler = resultHandlers[last.id] {
            handler(result)
            resultHandlers.removeValue(forKey: last.id)
        }
        paths.removeLast()
    }
    public func replace(_ context: RouteSetting) {
        if !paths.isEmpty {
            paths.removeLast()
        }
        paths.append(context)
    }
    public func popToRoot() {
        paths = []
    }
}

#if canImport(SwiftUI)
    import SwiftUI
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    extension DFRouter: ObservableObject {
        func notifyPathChange() {
            self.objectWillChange.send()
        }
        func routeView(for setting: RouteSetting) -> AnyView? {
            if let view = context.resolveRoute(setting) as? (any View) {
                return AnyView(view)
            }
            return nil
        }

    }
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public struct DFRouterView: View {
        @ObservedObject var router: DFRouter
        public init(router: DFRouter) {
            self.router = router
        }

        public var body: some View {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                NavigationStack(
                    path: Binding(
                        get: { router.paths },
                        set: { router.paths = $0 }
                    )
                ) {
                    // Root page
                    if let rootView = router.routeView(for: router.initRoute) {
                        rootView
                            .navigationDestination(for: DFRouter.RouteSetting.self) { setting in
                                router.routeView(for: setting)
                            }
                    } else {
                        Text("No route available")
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }

#endif
