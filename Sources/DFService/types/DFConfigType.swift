import Foundation

public protocol DFConfigType {
    var modules: [DFModuleType.Type] { get }
}


public struct AppConfig: DFConfigType {
    public var modules: [ DFModuleType.Type] = []
    
    public init() {
        
    }
}


