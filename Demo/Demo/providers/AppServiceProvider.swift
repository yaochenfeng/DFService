import DFService

class AppServiceProvider: ServiceProvider {
    override func register() {
        for provider in appProvider {
            app.provider(provider)
        }
        super.register()
        
        Router.shared.addPage(.detail) { req in
            let item = req.param as? Item ?? Item()
//            let timestap = item.timestamp ?? Date()
            Text("Select an item")
                .navigationTitle("标题")
        }
        .addPage(.demo) { req in
            DemoPage()
        }.addPage(.web) { req in
            WebView(req.url?.absoluteString ?? "")
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
    
    
    @ViewBuilder
    func buildRoot() -> some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.runtime.container.viewContext)
    }
}
