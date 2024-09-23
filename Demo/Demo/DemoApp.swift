//
//  DemoApp.swift
//  Demo
//
//  Created by yaochenfeng on 2024/8/22.
//

import SwiftUI
import DFService
enum SceneEnum: String {
    case main = ""
    case setting
}

@main
struct DemoApp: App {
    @Environment(\.scenePhase) var scenePhase
    init() {
        app.bootstrap(.eager)
    }
    @ObservedObject
    var app = Application.shared
    @SceneBuilder
    public var body: some Scene {
        WindowGroup() {
            SceneContent(.main, router: app[RouteService.self, SceneEnum.main.rawValue])
                .environmentObject(app)
                .environment(\.router, app[RouteService.self, SceneEnum.main.rawValue])
        }.onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                app.bootstrap(.window)
            case .background:
                break
            case .inactive:
                break
            @unknown default:
                break
            }
        }
        
        #if os(macOS)
        Settings {
            SceneContent(.setting, router: app[RouteService.self, SceneEnum.setting.rawValue])
                .environmentObject(app)
                .environment(\.router, app[RouteService.self, SceneEnum.setting.rawValue])
        }
        #endif
    }
}

struct SceneContent: View {
    let id: SceneEnum
    @ObservedObject
    var router: Router
//    @Environment(\.self)
//    var envValues
//    @Environment(\.router) var envRouter
    init(_ id: SceneEnum, router: Router) {
        self.id = id
        self._router = .init(wrappedValue: router)
    }
    
    @ViewBuilder
    var body: some View {
        RoutePage(router.rootPath)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
