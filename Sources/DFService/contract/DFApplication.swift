import SwiftUI

/// 应用协议
public protocol DFApplication: AnyObject {
    /// 应用默认注册的服务提供者
    var providerType: [ServiceProvider.Type] { get }
    /// 已注册的服务提供者
    var loadProviders: [ServiceProvider] { get set }
    var rootView: AnyView { get set }
}


public extension DFApplication {
    @discardableResult
    func provider<T: ServiceProvider>(_ serviceType: T.Type = T.self) -> T {
        
        let loadProvider = loadProviders.first { loaded in
            return loaded.name == serviceType.name
        }
        if let provider = loadProvider as? T {
            return provider
        }
        let provider = serviceType.init(self)
        loadProviders.append(provider)
        provider.register()
        return provider
    }
    
    
    func bootstrap(_ when: ServiceProvider.ProviderWhen) {
        provider(BootstrapServiceProvider.self).bootstrap(when)
    }
    /// 重置启动，执行provider Shutdown
    func reset(_ when: ServiceProvider.ProviderWhen) {
        provider(BootstrapServiceProvider.self).bootstrap(when)
    }
}
