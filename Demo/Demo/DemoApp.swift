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
        appService.bootstrap(.eager)
    }
    @ObservedObject
    var appService = ServiceValues[AppService.self]
    @SceneBuilder
    public var body: some Scene {
        WindowGroup {
            appService.rootView
        }
    }
}

