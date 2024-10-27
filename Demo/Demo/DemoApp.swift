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
struct DemoApp {
    public static func main() {
        SwiftApp.main()
    }

//    init() {
//        app.bootstrap(.eager)
//    }
//    var app: Application = .shared
//    @SceneBuilder
//    public var body: some Scene {
//        WindowGroup() {
//            SceneContent(.main)
//                .environmentObject(app)
//                .environment(\.router, app[RouteService.self, SceneEnum.main.rawValue])
//        }

//        #if os(macOS)
//        Settings {
//            SceneContent(.setting)
//        }
//        #endif
//    }
}

struct SceneContent: View {
    let id: SceneEnum
    @Environment(\.application) var app
    init(_ id: SceneEnum) {
        self.id = id
    }
    
    @ViewBuilder
    var body: some View {
        NavigationPage(router:  app[RouteService.self, id.rawValue])
            .onAppear {
                app.bootstrap(.window)
            }
            
    }
}
