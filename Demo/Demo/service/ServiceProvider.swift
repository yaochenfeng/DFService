//
//  serviceProvider.swift
//  Demo
//
//  Created by yaochenfeng on 2024/11/17.
//

import SwiftUI
import DFService

enum RoutePage: String, CaseIterable, Identifiable {
    case home
    case demo
    case test
    case movie
    
    var page: DemoPage{
        return DemoPage("\(self)")
    }
    var id: String {
        return rawValue
    }
}
struct ServiceProvider {
    static func boot() {
        let app = ServiceContainer.shared
        app[LogService.name] = LogServiceHandler()
        
        LogService.service(method: "log", args: "123")
        RouteService.shared
        .addPage("/") { arg in
            DemoPage("home")
        }
        .addPage("demo") { arg in
            DemoPage("demo")
        }
        .addPage("test") { arg in
            DemoPage("test")
        }
        
        RoutePage.allCases.forEach { item in
            RouteService.shared
                .addPage(item.rawValue) { arg in
                    item.page
            }
        }
    }
}


struct DemoPage: View {
    init(_ name: String) {
        self.name = name
    }
    
    @Environment(\.router)
    var router: RouteService
    let name: String
    
    var body: some View {
        ScaffoldView  {
            
            
            VStack {
                Text(name)
                Button("返回") {
                    router.pop()
                }
                Button("demo") {
                    router.pop(RouteSetting(name: "demo"))
                }
                
                ForEach(RoutePage.allCases) { item in
                    HStack {
                        Text("\(item.rawValue)")
                        Button("push") {
                            router.push(RouteSetting(name:item.rawValue))
                        }
                        Button("pop") {
                            router.pop(RouteSetting(name: item.rawValue))
                        }
                    }
                    
                }
            }
        }.navigationTitle(Text(name))
    }
}
