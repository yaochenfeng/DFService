public struct NavigationPage: View {
    @StateObject
    var router: Router
    
    public init(router: Router = .shared) {
        _router = .init(wrappedValue: router)
    }
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationStack(path: $router.pagePath) {
                RoutePage(router.rootPath)
                    .navigationDestination(for: RouteRequest.self) { arg in
                        RoutePage(arg)
                    }
                
                    .navigationDestination(isPresented: router.sheetBind) {
                        getSheetView()
                    }
            }
            .environment(\.router, router)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        else if Bool.app.uikit {
            Navigation(rootView: router.page(router.rootPath))
                .environment(\.router, router)
        }
        else {
            ZStack(alignment: .topLeading) {
                router.page(router.rootPath)
                    .environment(\.routeRequest, router.rootPath)
                    .sheet(isPresented: router.sheetBind) {
                        getSheetView()
                    }
                if let req = router.pagePath.last {
                    router.page(req)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .environment(\.routeRequest, req)
                }
                
            }
            .environment(\.router, router)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    func getSheetView() -> some View {
        
        if let request = router.presentingSheet {
            router.page(request)
                .environment(\.routeRequest, request)
        } else {
            EmptyView()
        }
    }
}

//struct NavigationPage_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationPage {
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//        }.environmentObject(Router.shared)
//    }
//}
#if canImport(UIKit)
import UIKit
extension NavigationPage {
    struct Navigation: UIViewControllerRepresentable {
        let rootView: AnyView
        func updateUIViewController(_ uiViewController: RouterNavigationController, context: Context) {
            uiViewController.environment = context.environment
        }
        
        typealias UIViewControllerType = RouterNavigationController
        
        func makeUIViewController(context: Context) -> RouterNavigationController {
            return RouterNavigationController(context.environment, root: rootView)
        }
    }
}
class RouterNavigationController: UINavigationController {
    var environment: EnvironmentValues
    let router: Router
    public init(_ environment: EnvironmentValues, root: AnyView) {
        self.environment = environment
        self.router = environment.router
        let controller = UIHostingController(rootView: root.environment(\.self, environment))
        super.init(rootViewController: controller)
    }
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router.customHandlerGo = { [weak self] req in
            guard let self = self else { return }
            let rootView = RoutePage(req)
                .environment(\.self, self.environment)
            let controller = UIHostingController(rootView: rootView)
            if req.routeType == .push {
                self.pushViewController(controller, animated: true)
            } else if req.routeType == .present {
                self.present(controller, animated: true)
            }
        }
        router.customHandlerPop = { [weak self] req in
            guard let self = self else { return }
            self.popViewController(animated: true)
        }
        router.customHandlerPopRoot = { [weak self] req in
            guard let self = self else { return }
            self.popToRootViewController(animated: true)
        }
    }
}
#else
extension NavigationPage {
    @available(iOS 8.0, *)
    struct Navigation: View {
        let rootView: AnyView
        var body: some View {
            EmptyView()
        }
    }
}
#endif


