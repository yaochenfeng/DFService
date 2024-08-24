public struct ServiceValues {
    public static var shared = ServiceValues()
    private var storage: [FactoryKey: Any] = [:]
    
    public init() {}
    
    public subscript<Service: DFApiService>(_ service: Service.Type) -> Service.Value {
        get {
            let key = FactoryKey(type: service)
            if let value = storage[key] as? Service.Value {
                return value
            }
            return service.defaultValue
        }
        set {
            let key = FactoryKey(type: service, name: service.serviceName)
            storage[key] = newValue
        }
    }
    public func findBy(_ name: ServiceName) -> DFApiCall? {
        guard let key = storage.keys.first(where: {$0.name == name}) else {
            return nil
        }
        guard let value = storage[key] as? DFApiCall else {
            return nil
        }
        return value
    }
}
