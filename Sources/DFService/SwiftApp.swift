import SwiftUI

open class SwiftApp: App, ObservableObject {
    public var loadProviders: [ServiceProvider] = []
    @Published
    public var rootView: AnyView = AnyView(EmptyView())
    required public init() {
        
    }
    
    @SceneBuilder
    public var body: some Scene {
        WindowGroup {
            
            rootView.chain(transform: { view in
                if #available(macOS 12.0, *) {
                    view.task {
                        self.bootstrap(.window)
                    }
                } else {
                    view.onAppear {
                        self.bootstrap(.window)
                    }
                }
            })
        }
    }
    
    open var providerType: [ServiceProvider.Type] {
        do {
            let provider = try Bundle.main.loadClass(ofType: ServiceProvider.self, named: "AppServiceProvider")
            return [provider]
        } catch {
            print("AppServiceProvider load err")
        }
        return []
    }
}

extension SwiftApp: DFApplication {}
