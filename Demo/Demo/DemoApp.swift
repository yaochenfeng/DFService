//
//  DemoApp.swift
//  Demo
//
//  Created by yaochenfeng on 2024/8/22.
//

import SwiftUI
import DFService
@main
class DemoApp: SwiftApp {
    let persistenceController = PersistenceController.shared
    
    required init() {
        super.init()
        self.rootView = AnyView(self.buildRoot())
        self.bootstrap(.eager)
    }
    
    @ViewBuilder
    func buildRoot() -> some View {
        NavigationView {
            Text("demo2sdf")
        }
        
    }
}
