//
//  ContainerProtocol.swift
//  
//
//  Created by yaochenfeng on 2023/6/22.
//

/// 容器管理
public protocol _ContainerProtocol {
    /// 注册
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
    /// 解析
    func resolve<T>(_ type: T.Type) -> T?
}
extension Container: _ContainerProtocol {
    public func register<T>(_ type: T.Type = T.self, factory: @escaping () -> T) {
        let identifier = ObjectIdentifier(type)
        services[identifier] = factory
    }
    
    public func resolve<T>(_ type: T.Type = T.self) -> T? {
        let identifier = ObjectIdentifier(type)
        if let instance = services[identifier] as? T {
            return instance
        } else if let factory = services[identifier] as? () -> T {
            return factory()
        } else if let factory = services[identifier] as? () -> Any {
            return factory() as? T
        }
        return nil
    }
    public func resolve<T>(_ type: T.Type = T.self) throws -> T {
        if let instance = resolve(T.self) {
            return instance
        }
        throw DFError.notFound
    }
}
