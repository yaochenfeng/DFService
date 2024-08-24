//
//  DemoApp.swift
//  Demo
//
//  Created by yaochenfeng on 2024/8/22.
//

import SwiftUI
import DFService
@main
struct DemoApp: App {
    init() {
        context.bootstrap(.eager)
    }
    @ObservedObject
    var context = AppContext()
    @SceneBuilder
    public var body: some Scene {
        WindowGroup {
            context.rootView
        }
    }
}

extension DemoApp {
    class AppContext: DFApplication, ObservableObject {
        var providerType: [ServiceProvider.Type] {
            return [AppServiceProvider.self]
        }
        
        var loadProviders: [ServiceProvider] = []
        
        @Published
        var rootView: AnyView = AnyView(EmptyView())
    }
}

