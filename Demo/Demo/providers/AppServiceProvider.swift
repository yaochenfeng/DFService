import DFService

class AppServiceProvider: ServiceProvider {
    override func register() {
        for provider in appProvider {
            app.provider(provider)
        }
        super.register()
        
        
    }

    var appProvider: [ServiceProvider.Type] {
        return [
            RouteServiceProvider.self,
        ]
    }
    
    override var when: ProviderWhen {
        .eager
    }
}
