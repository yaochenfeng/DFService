/// DFAppContext.swift
open class DFAppContext {
    public static var shared = DFAppContext()

    public init() {}

    var moduleMap: [String: DFModuleType] = [:]
}

extension DFAppContext {
    @discardableResult
    public func get<T: DFModuleType>(module: T.Type) -> T {
        let moduleName = T.moduleName
        if let moduleInstance = getModule(moduleName) as? T {
            return moduleInstance
        }
        let moduleInstance = T.init()
        moduleMap[moduleName] = moduleInstance
        return moduleInstance
    }
    public func getModule(_ moduleName: String) -> DFModuleType? {
        return moduleMap[moduleName]
    }
    public func unregister(moduleName: String) {
        moduleMap.removeValue(forKey: moduleName)
    }

    public func contain(moduleName: String) -> Bool {
        return moduleMap[moduleName] != nil
    }

    public var allModules: [DFModuleType] {
        return moduleMap.values.map { $0 }
    }
}
