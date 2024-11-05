import Foundation

public protocol ServiceKey {
    static var name: String { get }
    init()
}

public extension ServiceKey {
    static func get(_ provider: ServiceFactory = .shared) -> Service<Self> {
        return Service(Self.init(), provider: provider)
    }
    func get(_ provider: ServiceFactory = .shared) -> Service<Self> {
        return Service(self, provider: provider)
    }
}
