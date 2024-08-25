import SwiftUI
public protocol DFApiService: EnvironmentKey {
    associatedtype Value
    static var defaultValue: Self.Value { get }
}

extension DFApplication {
    public subscript<Service: DFApiService>(service: Service.Type) -> Service.Value {
        get {
            return serviceValues[service]
        }
        set {
            ServiceValues.shared[service] = newValue
        }
    }
}

protocol LogHandle {
    func log()
}

struct Mock: LogHandle {
    func log() {
        
    }
}
