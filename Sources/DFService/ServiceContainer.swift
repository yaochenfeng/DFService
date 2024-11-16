import Foundation
/**
 * 服务容器
 */
public final class ServiceContainer {
    public static let shared = ServiceContainer()
    let serviceManager = ServiceManger()
    public init() {}
}
