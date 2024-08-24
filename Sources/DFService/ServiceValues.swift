public struct ServiceValues {
  public static let version = "0.1.0"

  public static var shared = ServiceValues()
  private var storage: [FactoryKey: Any] = [:]
  private var serviceNames: [ServiceName: FactoryKey] = [:]

  public init() {}

}

extension ServiceValues {
  public static subscript<Service: DFApiService>(service: Service.Type, tag: String = "")
    -> Service.Value
  {
    get {
      return Self.shared[service, tag]
    }
    set {
      Self.shared[service, tag] = newValue
    }
  }
  public subscript<Service: DFApiService>(service: Service.Type, tag: String = "") -> Service.Value
  {
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
  public subscript<Service: DFApiService>(_ name: ServiceName, tag: String = "") -> Service.Type? {
    set {
      guard newValue != nil else {
        serviceNames[name] = nil
        return
      }
      let value = FactoryKey(type: Service.self)
      serviceNames[name] = value
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

#if canImport(SwiftUI)
  import SwiftUI
  extension EnvironmentValues {
    public var serviceValues: ServiceValues {
      return ServiceValues.shared
    }
  }
#endif
