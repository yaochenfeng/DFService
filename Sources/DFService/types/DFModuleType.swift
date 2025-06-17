//
//  File.swift
//
//
//  Created by yaochenfeng on 2025/6/7.
//

import Foundation
public struct ServiceEvent {
    public let name: String
    public let payload: Any
    public init(name: String, payload: Any = ()) {
        self.name = name
        self.payload = payload
    }
}
public struct ServicePhase: Comparable, RawRepresentable {
    // 内置阶段
    public static let initial = ServicePhase(rawValue: 0)  // 初始阶段
    public static let splash = Self.initial.next(step: 10)  // 启动阶段

    public var rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static func == (lhs: ServicePhase, rhs: ServicePhase) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    public static func < (lhs: ServicePhase, rhs: ServicePhase) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    // 通过已有阶段生成新阶段示例
    public func next(step: Int = 1) -> ServicePhase {
        return ServicePhase(rawValue: self.rawValue + step)
    }
}

public protocol DFModuleType: AnyObject {
    init(_ manager: ServiceManager)
    static var name: String { get }
    // ren阶段
    var taskPhases: [ServicePhase] { get }

    @MainActor func run(phase: ServicePhase)
    /// 处理事件（可选实现）
    func handle(event: ServiceEvent)
}

extension DFModuleType {
    public static var name: String {
        return String(describing: self)
    }

    // 默认实现，子类可以覆盖
    public var taskPhases: [ServicePhase] {
        return [.splash]
    }
    
    func handle(event: ServiceEvent) {
        
    }
}
