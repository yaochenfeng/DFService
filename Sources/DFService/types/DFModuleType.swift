import Foundation

public protocol DFModuleType: AnyObject {
    static var moduleName: String { get }
    init()

    // func canHandpag(_ route: String) -> Bool
    func canHandleRoute(_ context: DFRouter.RouteSetting) -> Bool
    func resolveRoute(_ context: DFRouter.RouteSetting) -> Any?
}

extension DFModuleType {
    public static var moduleName: String {
        return String(describing: self)
    }
}

extension DFAppContext {
    public func canHandleRoute(_ setting: DFRouter.RouteSetting) -> Bool {
        return allModules.contains { $0.canHandleRoute(setting) }
    }

    func resolveRoute(_ setting: DFRouter.RouteSetting) -> Any? {
        return allModules.first { $0.canHandleRoute(setting) }?.resolveRoute(setting)
    }
}
