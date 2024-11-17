//
//  SwiftUIView.swift
//  
//
//  Created by yaochenfeng on 2024/11/17.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
import Combine
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct iOSNavigationView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIViewController(context: Context) -> iOSNavigationController {
        context.coordinator.updateBinds(context: context)
        return context.coordinator.router.navigation
    }
    
    func updateUIViewController(_ uiViewController: iOSNavigationController, context: Context) {
        updateViewControllers(uiViewController, context: context)
    }
    private func updateViewControllers(_ navigationController: UINavigationController, context: Context) {
        context.coordinator.updateBinds(context: context)
    }
    
    typealias UIViewControllerType = iOSNavigationController
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate {
        var router = RouteService.shared
        var cancellable: AnyCancellable?
        
        deinit {
            cancellable?.cancel()
        }
        func updateBinds(context: Context) {
            router = context.environment.router
            let navigation = router.navigation
            navigation.environment = context.environment
            navigation.delegate = self
            cancellable?.cancel()
            cancellable = router.$initRoute
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] arg in
                    self?.router.navigation.setRoot()
                })
        }
        
    }
    
}
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct iOSNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        iOSNavigationView()
    }
}

#else
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct iOSNavigationView: View {
    var body: some View {
        EmptyView()
    }
}

#endif

#if canImport(UIKit)

@available(tvOS 14.0, *)
@available(macCatalyst 14.0, *)
@available(iOS 14.0, *)
class iOSNavigationController: UINavigationController {
    @MainActor
    public var environment = EnvironmentValues()
    @MainActor
    func setRoot() {
        let router = environment.router
        let page = router.page(router.initRoute)
        let rootView = page
        let controller = RouteController(setting: page.setting, rootView: rootView)
        setViewControllers([controller], animated: false)
    }
    @MainActor
    func push(_ setting: RouteSetting, animated: Bool) -> Bool {
        if #available(iOS 16.0, *) {
            return false
        }
        let router = environment.router
        let page = router.page(setting)
        let rootView = page.environment(\.self, environment)
        let controller = RouteController(setting: setting, rootView: rootView)
        self.pushViewController(controller, animated: animated)
        return true
    }
    @MainActor
    func pop(_ setting: RouteSetting? = nil, animated: Bool = true) -> Bool {
        if #available(iOS 16.0, *) {
            return false
        }
        if viewControllers.count <= 1 {
            return true
        } else {
            for viewController in self.viewControllers {
                if let routable = viewController as? RouteController,
                   routable.routeSetting.name == setting?.name {
                    self.popToViewController(viewController, animated: animated)
                    return true
                }
            }
            self.popViewController(animated: animated)
        }
        return true
    }
    class RouteController: UIHostingController<AnyView> {
        let routeSetting: RouteSetting
        
        init<Content: View>(setting: RouteSetting, rootView: Content) {
            self.routeSetting = setting
            super.init(rootView: AnyView(rootView))
        }
        
        @available(*, deprecated)
        required dynamic init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
#else
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
class iOSNavigationController {
    func push(_ setting: RouteSetting, animated: Bool) -> Bool {
        return false
    }
    func pop(_ setting: RouteSetting? = nil, animated: Bool = true) -> Bool {
        return false
    }
}
#endif
