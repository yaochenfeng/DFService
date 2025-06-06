//
//  ExampleApp.swift
//  Example
//
//  Created by yaochenfeng on 2025/6/7.
//

import SwiftUI
import DFService
import DFBase

@main
struct ExampleApp: App {
    init() {
        self.store.dispatch(.setRoot(AnyView(ContentView())))
    }
    @ObservedObject var store = ServiceStore(state: AppState())
    var body: some Scene {
        WindowGroup {
            store.state.root
                .environmentObject(store)
        }
    }
}
