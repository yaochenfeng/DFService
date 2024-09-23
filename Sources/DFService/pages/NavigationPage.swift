public struct NavigationPage: View {
    let rootView: AnyView
    @ObservedObject
    var router: Router
    
    public init(router: Router = .shared, @ViewBuilder builder: () -> some View) {
        _router = .init(initialValue: router)
        rootView = AnyView(builder())
    }
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationStack(path: $router.pagePath) {
                rootView
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        else if Bool.app.uikit {
            Navigation(rootView: rootView)
                .environment(\.router, router)
        }
        else {
            ZStack(alignment: .topLeading) {
                rootView
                if let req = router.pagePath.last {
                    router.page(req)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct NavigationPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationPage {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }.environmentObject(Router.shared)
    }
}
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
            let controller = UIHostingController(rootView: RoutePage(req).environment(\.self, self.environment))
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


