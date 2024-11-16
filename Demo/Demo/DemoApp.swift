//
//  DemoApp.swift
//  Demo
//
//  Created by yaochenfeng on 2024/8/22.
//

import SwiftUI
import DFService

@main
struct DemoApp {
    public static func main() {
        ServiceProvider.boot()
        ServiceApp.main()
    }
}
