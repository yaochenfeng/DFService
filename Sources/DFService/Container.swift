//
//  Container.swift
//  
//
//  Created by yaochenfeng on 2023/6/22.
//

/// 容器管理
public class Container {
    public internal(set) var id: String
    public init(_ id: String) {
        self.id = id
    }
    internal static var shared = Container("shared")
    internal var environment = Environment()
    internal var services: [ObjectIdentifier: Any] = [:]
}

public extension Container {
    var isShared: Bool {
        return self === Container.shared
    }
}

public let DF = Container.shared
