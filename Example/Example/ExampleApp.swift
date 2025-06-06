//
//  ExampleApp.swift
//  Example
//
//  Created by yaochenfeng on 2025/6/7.
//

import DFBase
import DFService
import SwiftUI

@main
struct ExampleApp: App {
    init() {
    }
    var body: some Scene {
        
        WindowGroup {
            PagePrviewView {
                ContentView()
            }
        }
    }
}


struct PagePrviewView: View {
    @ObservedObject var store: ServiceStore<AppState> = ServiceStore(state: AppState.shared)
    init<Page: View>(@ViewBuilder content: () -> Page) {
        store.dispatch(.setRoot(AnyView(content())))
    }

    var body: some View {
        store.state.root
            .environment(\.appStore, store)
    }
}
