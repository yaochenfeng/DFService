//
//  Container.Env.swift
//  
//
//  Created by yaochenfeng on 2023/6/22.
//
import Foundation

public extension Container {
    struct Environment {
        var map = [String: Any]()
        
        init() {
            self.map = ProcessInfo.processInfo.environment
        }
        
        public var isUnitTests: Bool {
            return true
        }
        public var isProduction: Bool {
            return current == "production"
        }
        public var current = "production"
    }
    /// 自定义环境变量读取设置
    subscript(env: String) -> String? {
        get {
            environment.map[env] as? String
        }
        set {
            environment.map[env] = newValue
        }
    }
    subscript<T>(env keyPath: KeyPath<Environment, T>) -> T {
        get {
            return environment[keyPath: keyPath]
        }
        set {
            if let path = keyPath as? WritableKeyPath<Environment, T> {
                environment[keyPath: path] = newValue
            }
        }
    }
    /// 获取当前环境变量
    func getEnvironments() -> [String: String] {
        var map = environment.map.compactMapValues { $0 as? String }
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            print("\(child.label!)---\(child.value)")
        }
        map = mirror.children.reduce(into: map) { partialResult, tuple in
            if let k = tuple.label, let value = tuple.value as? String {
                partialResult[k] = value
            }
        }
        return map
    }
}
