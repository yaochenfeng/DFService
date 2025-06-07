import DFBase
//
//  EntryModule.swift
//  Example
//
//  Created by yaochenfeng on 2025/6/7.
//
import DFService
import SwiftUI

class AppModule: ServiceModuleType {
    required init(_ manager: DFService.ServiceManager) {

    }

    var taskPhases: [DFService.ServicePhase] = [.initial]

    func run(phase: DFService.ServicePhase) {
        AppState.store(.setRoot(AnyView(SplashPageView())))
    }

    func handle(event: DFService.ServiceEvent) {
        // 处理事件逻辑
        print("Received event: \(event.name) with payload: \(event.payload)")
    }

}
