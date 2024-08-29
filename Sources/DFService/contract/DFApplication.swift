import SwiftUI

/// 应用协议
public protocol DFApplication: AnyObject {
    /// 应用默认注册的服务提供者
    var providerType: [ServiceProvider.Type] { get }
    /// 已注册的服务提供者
    var loadProviders: [ServiceProvider] { get set }
    
    subscript<Service: DFServiceKey>(service: Service.Type, tag: String) -> Service.Value { get set }
}
