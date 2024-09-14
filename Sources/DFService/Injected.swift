@propertyWrapper
public struct Injected<Service: DFServiceKey> {
    let app: Application
    public init(_ service:Service.Type = Service.self,
                _ app: Application = .shared) {
        self.app = app
    }
    public var wrappedValue: Service.Value {
        return app[Service.self]
    }
}
