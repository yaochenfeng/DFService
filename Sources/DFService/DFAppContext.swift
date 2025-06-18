import Foundation

public final class DFAppContext {
    public static let shared = DFAppContext()
    
    public init(_ config: DFConfigType = AppConfig()) {
        self.config = config
    }
    public var config: DFConfigType
    var moduleMap: [String: DFModuleType] = [:]
}
