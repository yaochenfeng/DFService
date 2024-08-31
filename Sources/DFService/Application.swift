import SwiftUI

public class Application {
    public static let version = "0.1.0"
    fileprivate static var _instance: Application?
    public var loadProviders: [DFService.ServiceProvider] = []
    private var storage: [FactoryKey: Any] = [:]
    private var serviceNames: [ServiceName: FactoryKey] = [:]
    public required init() {}
}

extension Application: DFApplication {
    public subscript<Service>(service: Service.Type, tag: String = "") -> Service.Value where Service : DFServiceKey {
        get {
            let key = FactoryKey(type: service, tag: tag)
            if let value = storage[key] as? Service.Value {
                return value
            }
            return service.defaultValue
        }
        set {
            let key = FactoryKey(type: service, tag: tag)
            storage[key] = newValue
        }
    }
    
    public var providerType: [DFService.ServiceProvider.Type] {
        return []
    }
    
    public static var shared: Application {
        if let value = _instance {
            return value
        }
        let value = Application()
        _instance = value
        do {
            let provider = try Bundle.main.app.loadClass(ofType: ServiceProvider.self, named: "AppServiceProvider")
            value.provider(provider)
        } catch {
            
        }
        return value
    }
}

extension Application {
    public subscript<Service: DFServiceKey>(_ name: ServiceName, tag: String = "") -> Service.Type? {
        set {
            guard newValue != nil else {
                serviceNames[name] = nil
                return
            }
            let value = FactoryKey(type: Service.self)
            serviceNames[name] = value
            if(storage[value] == nil) {
                storage[value] = Service.defaultValue
            }
        }
        
        get {
            serviceNames[name]?.type as? Service.Type
        }
    }
    
    public func findBy(_ name: ServiceName) -> DFApiCall? {
        guard let key = serviceNames[name] else {
            return nil
        }
        guard let value = storage[key] as? DFApiCall else {
            return nil
        }
        return value
    }
}

extension Application: ObservableObject {}

struct AppEnvironmentKey: EnvironmentKey {
    static var defaultValue = Application.shared
}

extension EnvironmentValues {
    public var application: Application {
        get {
            return self[AppEnvironmentKey.self]
        }
        set {
            self[AppEnvironmentKey.self] = newValue
        }
    }
}
