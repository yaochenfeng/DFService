public final class ServiceManager {
    public static var shared = ServiceManager()
    public init() {}

    private var modules: [String: DFModuleType] = [:]

    @MainActor
    public func runAll(phase: ServicePhase) {
        modules.values
            .filter { $0.taskPhases.contains(phase) }
            .forEach { $0.run(phase: phase) }
    }
}

extension ServiceManager {
    public func register<Module: DFModuleType>(_ module: Module) {
        modules[Module.name] = module
    }
    public func register<Module: DFModuleType>(_ module: Module.Type = Module.self) {
        let value = module.init(self)
        register(value)
    }
    // 通过模块名称获取模块实例
    public func getModule(named name: String) -> DFModuleType? {
        return modules[name]
    }

    // 通过模块类型获取模块实例
    public func getModule<T: DFModuleType>(byType type: T.Type) -> T? {
        return modules.values.first(where: { $0 is T }) as? T
    }
    public func sendEvent(_ event: ServiceEvent, to moduleName: String? = nil) {
        if let moduleName = moduleName {
            // 只发给指定模块
            modules[moduleName]?.handle(event: event)
        } else {
            // 广播给所有模块
            for module in modules.values {
                module.handle(event: event)
            }
        }
    }
}
