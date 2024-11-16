import SwiftUI

public struct NavigationPage: View {
    @StateObject
    var router: Router
    
    public init(router: Router = .shared) {
        _router = .init(wrappedValue: router)
    }
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationStack(path: $router.pagePath) {
                HookNavigation {
                    RoutePage(router.rootPath)
                }
                .navigationDestination(for: RouteRequest.self) { arg in
                    RoutePage(arg)
                }
                
                .navigationDestination(isPresented: router.sheetBind) {
                    getSheetView()
                }
            }
            .environment(\.router, router)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if Bool.app.uikit {
            NavigationView {
                HookNavigation {
                    RoutePage(router.rootPath)
                }
            }
            .chain { view in
                if #available(iOS 13, tvOS 13, *) {
#if os(macOS)
                    view
#else
                    view.navigationViewStyle(.stack)
#endif
                } else {
                    view
                }
            }
            .environment(\.router, router)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } else {
            ZStack(alignment: .topLeading) {
                HookNavigation {
                    RoutePage(router.rootPath)
                }
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .environment(\.router, router)
        }
    }
    
    @ViewBuilder
    func getSheetView() -> some View {
        if let request = router.presentingSheet {
#if os(macOS)
            
            VStack(alignment: .center) {
                RoutePage(request)
            }.padding()
            
#else
            RoutePage(request)
#endif
        } else {
            EmptyView()
        }
    }
}

struct HookNavigation<Content: View>: View {
    let content: Content
    var body: some View {
#if canImport(UIKit)
        ZStack {
            HookController()
            content
        }
#else
        content
#endif
    }
    init(content builder: () -> Content) {
        self.content = builder()
    }
}

#if canImport(UIKit)
import UIKit
struct HookController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> Hook {
        return Hook(environment: context.environment)
    }
    
    func updateUIViewController(_ uiViewController: Hook, context: Context) {
        uiViewController.environment = context.environment
    }
    
    typealias UIViewControllerType = Hook
    
    
    class Hook: UIViewController, UIGestureRecognizerDelegate {
        var environment: EnvironmentValues
        
        init(environment: EnvironmentValues) {
            self.environment = environment
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            self.environment = .init()
            super.init(coder: coder)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if environment.router.controller != navigationController {
                bindRouter()
            }
        }
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard let nav = environment.router.controller else {
                return false
            }
            return nav.viewControllers.count > 1
        }
        func bindRouter() {
            guard let nav = navigationController else {
                return
            }
            
            let router = environment.router
            router.controller = nav
#if os(iOS)
            nav.interactivePopGestureRecognizer?.delegate = self
#endif
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                return
            }
            
            router.customHandlerGo = { [weak self] req in
                guard let self = self else { return }
                let rootView = RoutePage(req)
                    .environment(\.self, self.environment)
                let controller = UIHostingController(rootView: rootView)
                if req.routeType == .push {
                    nav.pushViewController(controller, animated: true)
                } else if req.routeType == .present {
                    nav.present(controller, animated: true)
                }
            }
            router.customHandlerPop = { [weak nav] req in
                guard let self = nav else { return }
                if let presentedViewController = self.topViewController?.presentedViewController {
                    presentedViewController.dismiss(animated: true)
                } else {
                    self.popViewController(animated: true)
                }
            }
            router.customHandlerPopRoot = { [weak nav] req in
                guard let self = nav else { return }
                self.popToRootViewController(animated: true)
            }
        }
    }
}


#endif
