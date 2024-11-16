import Foundation

public protocol ServiceKey {
    static var name: String { get }
    static var shared: Self { get }
    init()
}

extension ServiceKey {
    public static var service: Service<Self> {
        let key = Self.shared
        return ServiceContainer.shared.getOrMock(key)
    }
}
