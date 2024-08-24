import Foundation

actor Bootstrap {
    private weak var app: DFApplication?
    
    private var current: ServiceProvider.ProviderWhen = .eager
    private var target: ServiceProvider.ProviderWhen = .eager
    private var isRunning = false
    init(app: DFApplication) {
        self.app = app
    }
    
    func bootstrap(_ when: ServiceProvider.ProviderWhen) async {
        target = when
        await bootIfNeed()
    }
    
    func bootIfNeed() async {
        guard let app = app else {
            return
        }
        let currentProviders = app.loadProviders.filter { provider in
            return !provider.isBooted && provider.when <= current
        }
        
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
            await provider.performAsyncStartup()
            success = true
            provider.isBooted = true
            
        }
        self.isRunning = false
        await bootIfNeed()
    }
}

class BootstrapServiceProvider: ServiceProvider {
    let bootstrap: Bootstrap
    required init(_ app: DFApplication) {
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
}
