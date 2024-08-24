public struct AppService: DFApiService {
    public static var defaultValue: Value {
        return Value.shared
    }
}

extension AppService {
    open class Value: DFApplication, ObservableObject {
        
        internal static var shared = Value()
        public init() {}
        public var providerType: [ServiceProvider.Type] {
            do {
                let provider = try Bundle.main.app.loadClass(ofType: ServiceProvider.self, named: "AppServiceProvider")
                return [provider]
            } catch {
                return []
            }
        }
        
        public var loadProviders: [ServiceProvider] = []
        
        @Published
        public var rootView: AnyView = AnyView(RouterView())
    }
}
