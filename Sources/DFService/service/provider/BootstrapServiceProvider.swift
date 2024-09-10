import Foundation

actor Bootstrap {
    private weak var app: Application?
    
    private var current: ServiceProvider.ProviderWhen = .eager
    private var target: ServiceProvider.ProviderWhen = .eager
    private var isRunning = false
    init(app: Application) {
        self.app = app
    }
    
    func bootstrap(_ when: ServiceProvider.ProviderWhen) async {
        if(target < when) {
            target = when
        }
        await bootIfNeed()
    }
    
    func bootIfNeed() async {
        guard let app = app else {
            return
        }
        let currentProviders = app.loadProviders.filter { provider in
            return !provider.isBooted && provider.when <= current
        }.sorted()
        
        guard !currentProviders.isEmpty else {
            if current < target {
                current = current + 1
                await bootIfNeed()
            }
            return
        }
        guard !isRunning else {
            return
        }
        self.isRunning = true
        for provider in currentProviders where !provider.isBooted {
            let start_time = CFAbsoluteTimeGetCurrent()
            var success = false
            defer {
                let end_time = CFAbsoluteTimeGetCurrent()
                let cost_time = (end_time - start_time) * 1000
                app[LogService.self].debug("\(provider.name) 启动\(success)用时: \(cost_time)毫秒")
            }
            do {
                try await provider.performAsyncStartup()
                provider.isBooted = true
                success = true
            } catch {
                app[LogService.self].warning("\(provider.name) 启动失败\(error)")
                return
            }
        }
        self.isRunning = false
        await bootIfNeed()
    }
}

class BootstrapServiceProvider: ServiceProvider {
    let bootstrap: Bootstrap
    required init(_ app: Application) {
        bootstrap = Bootstrap(app: app)
        super.init(app)
    }
    override func register() {
        app.providerType.forEach { serviceType in
            app.provider(serviceType)
        }
    }
    func bootstrap(_ when: ProviderWhen) {
        Task(priority: .userInitiated){
            await bootstrap.bootstrap(when)
        }
    }
    
    func reset(_ when: ProviderWhen) {
        
    }
    
    override var when: ServiceProvider.ProviderWhen {
        return .eager
    }
    
    override var sortIndex: Int {
        return 0
    }
}



public extension Application {
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
