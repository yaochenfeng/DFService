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
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct iOSNavigationView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        context.coordinator.updateBinds(context: context)
        return context.coordinator.navigation
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        updateViewControllers(uiViewController, context: context)
    }
    private func updateViewControllers(_ navigationController: UINavigationController, context: Context) {
            context.coordinator.updateBinds(context: context)
        }
    
    typealias UIViewControllerType = UINavigationController
    
    
    class Coordinator: NSObject {
        let navigation = UINavigationController(rootViewController: UIViewController())
        var cancellable: AnyCancellable?
        
        deinit {
            cancellable?.cancel()
        }
        func updateBinds(context: Context) {
            cancellable?.cancel()
            let router = context.environment.router
            cancellable = router.$pages
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] arg in
                    self?.updateViewControllers(context: context)
                })
        }
        
        
        private func updateViewControllers(context: Context) {
            let navigationController = navigation
            let router = context.environment.router
            let animated = context.transaction.animation != nil
            let pages = [router.page(router.initRoute)] + router.pages
                let viewControllers = pages.map { page in
                    let controller = UIHostingController(rootView: page.environment(\.self, context.environment))
                    return controller
                }
                navigationController.setViewControllers(viewControllers, animated: animated)
            }
    }
    
}
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct iOSNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        iOSNavigationView()
    }
}
#endif
