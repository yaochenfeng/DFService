import Foundation

public final class AppContext {
    public static let shared = AppContext()
    
    public init(_ config: DFConfigType = AppConfig()) {
        self.config = config
    }
    public var config: DFConfigType
    var moduleMap: [String: DFModuleType] = [:]
}
