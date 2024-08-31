//
//  AppStorage.swift
//  Demo
//
//  Created by yaochenfeng on 2024/8/31.
//

import Foundation
import DFService

struct AppStorageKey: DFServiceKey {
    static var defaultValue = AppState()
}

extension Application {
    var state: AppState {
        get {
            self[AppStorageKey.self]
        }
        set {
            self[AppStorageKey.self] = newValue
        }
    }
}

struct AppState {
    var agreePrivacy = false
    var isLogin = false
}
