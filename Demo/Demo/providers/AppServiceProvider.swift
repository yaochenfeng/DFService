import DFService

class AppServiceProvider: ServiceProvider {
    override func register() {
        for provider in appProvider {
            app.provider(provider)
        }
        super.register()
        Router.shared.add(pid: .root) { _ in
            self.buildRoot()
        }
        
        Router.shared.add(pid: .detail) { req in
            let item = req.options["data"] as? Item ?? Item()
            let timestap = item.timestamp ?? Date()
            Text("Select an item \(timestap)")
        }
    }

    var appProvider: [ServiceProvider.Type] {
        return [
            RouteServiceProvider.self,
        ]
    }
    
    override var when: ProviderWhen {
        .eager
    }
    
    override func performAsyncStartup() async {
        DispatchQueue.main.async {
//            self.app.rootView = AnyView(self.buildRoot())
        }
    }
    
    
    @ViewBuilder
    func buildRoot() -> some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.runtime.container.viewContext)
    }
}
