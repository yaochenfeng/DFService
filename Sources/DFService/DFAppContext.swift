import Foundation

public final class DFAppContext {
    public static var shared = DFAppContext()
    public init() {
    }
    var moduleMap: [String: DFModuleType] = [:]
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension DFAppContext: ObservableObject {
    
}
