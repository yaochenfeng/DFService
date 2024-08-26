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
    @Environment(\.scenePhase) var scenePhase
    init() {
        appService.bootstrap(.eager)
    }
    @ObservedObject
    var appService = ServiceValues[AppService.self]
    @SceneBuilder
    public var body: some Scene {
        WindowGroup {
            appService.rootView
                .chain { view in
                    if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                        view.task {
                            appService.bootstrap(.root)
                        }
                    } else {
                        view.onAppear {
                            appService.bootstrap(.root)
                        }
                    }
                }
        }.onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                appService.bootstrap(.window)
            case .background:
                break
            case .inactive:
                break
            @unknown default:
                break
            }
        }
    }
}

