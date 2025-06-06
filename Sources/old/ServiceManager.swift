import Foundation

class ServiceManger {
    var storage: [String: ServiceHandler] = [:]
}

extension ServiceContainer {
    public subscript(name: String) -> ServiceHandler? {
        get {
            let key = name
            return serviceManager.storage[key]
        }
        set {
            let key = name
            serviceManager.storage[key] = newValue
        }
    }
    public func get<Key: ServiceKey>(_ key: Key) -> Service<Key>? {
        let name = Key.name
        if let handler = self[name] {
            return Service(key, handler: handler)
        } else if let handler = key as? ServiceHandler {
            return Service(key, handler: handler)
        }
        return nil
    }
    
    public func getOrMock<Key: ServiceKey>(_ key: Key) -> Service<Key> {
        if let value = self.get(key) {
            return value
        }
        let name = Key.name
        return Service(Key.shared, handler: ServiceMockHandler(name: name))
    }
}
