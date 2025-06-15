////
////  ExampleApp.swift
////  Example
////
////  Created by yaochenfeng on 2025/6/7.
////
//
//import DFService
//import SwiftUI
//
//@main
//struct ExampleApp: App {
//    let manager = ServiceManager.shared
//    init() {
//        // 注册模块 AppModule
//        // bundle main name
//        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String,
//           let cls = NSClassFromString("\(appName).AppModule") as? ServiceModuleType.Type {
//            manager.register(cls)
//        }
//        manager.runAll(phase: .initial)
//
//    }
//    var body: some Scene {
//
//        WindowGroup {
//            PagePrviewView()
//            
//        }
//    }
//}
//
//struct PagePrviewView: View {
//    @ObservedObject var store: ServiceStore<AppState> = AppState.store
//    init<Page: View>(@ViewBuilder content: () -> Page) {
//        store.dispatch(.setRoot(AnyView(content())))
//    }
//    init() {
//        
//    }
//
//    var body: some View {
//        store.state.root
//            .environment(\.appStore, store)
//    }
//}
