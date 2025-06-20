import Foundation

public protocol DFModuleType: AnyObject {
    static var moduleName: String { get }
    init()
    
}
extension DFModuleType {
    public static var moduleName: String {
        return String(describing: self)
    }
}

extension DFAppContext {
    public func contain(moduleName: String) -> Bool {
        return moduleMap[moduleName] != nil
    }
    public func get<M: DFModuleType>(module: M.Type = M.self) -> M {
        if let module = moduleMap[M.moduleName] as? M {
            return module
        }
        let module = M.init()
        moduleMap[M.moduleName] = module
        return module
    }

    public func getAllModules() -> [DFModuleType] {
        return Array(moduleMap.values)
    }
}
