//
//  serviceProvider.swift
//  Demo
//
//  Created by yaochenfeng on 2024/11/17.
//

import Foundation
import DFService

struct ServiceProvider {
    static func boot() {
        let app = ServiceContainer.shared
        app[LogService.name] = LogServiceHandler()
        
        LogService.service(method: "log", args: "123")
        
    }
}
