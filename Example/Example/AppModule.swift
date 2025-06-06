//
//  EntryModule.swift
//  Example
//
//  Created by yaochenfeng on 2025/6/7.
//
import DFService
import SwiftUI
import DFBase


class AppModule: ServiceModuleType {
    required init(_ manager: DFService.ServiceManager) {
        
    }
    
    var taskPhases: [DFService.ServicePhase] = [.initial]
    
    func run(phase: DFService.ServicePhase) {
        AppState.store(.setRoot(AnyView(SplashPageView())))
    }
    
}
