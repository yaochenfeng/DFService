public final class ServiceManager {
    public static var shared = ServiceManager()
    public init() {}

    private var modules: [String: ServiceModuleType] = [:]

    @MainActor
    public func runAll(phase: ServicePhase) {
        modules.values
            .filter { $0.taskPhases.contains(phase) }
            .forEach { $0.run(phase: phase) }
    }
}

extension ServiceManager {
    public func register<Module: ServiceModuleType>(_ module: Module) {
        modules[Module.name] = module
    }
    public func register<Module: ServiceModuleType>(_ module: Module.Type = Module.self) {
        let value = module.init(self)
        register(value)
    }
    // 通过模块名称获取模块实例
    public func getModule(named name: String) -> ServiceModuleType? {
        return modules[name]
    }

    // 通过模块类型获取模块实例
    public func getModule<T: ServiceModuleType>(byType type: T.Type) -> T? {
        return modules.values.first(where: { $0 is T }) as? T
    }
}
