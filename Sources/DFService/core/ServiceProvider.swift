/// 应用内服务提供者
/// 在应用不同时机启动服务
open class ServiceProvider {
    public let app: DFApplication
    /// 服务是否启动
    public internal(set) var isBooted: Bool = false
    public required init(_ app: DFApplication) {
        self.app = app
    }
    /// 注册服务
    open func register() {}
    /// 模拟异步启动逻辑
    open func performAsyncStartup() async {
        // 重写此方法以实现实际的异步启动逻辑
//         try? await Task.sleep(nanoseconds: 1_000_000_000)// 模拟1秒的异步启动
    }
    
    /// 模拟异步关闭逻辑
    open func performAsyncShutdown() async {
        // 重写此方法以实现实际的异步关闭逻辑
//        try await Task.sleep(nanoseconds: 1_000_000_000) // 模拟1秒的异步关闭
    }
    open var when: ProviderWhen {
        return .root
    }
    
    var name: String {
        return Self.name
    }
}


extension ServiceProvider: Equatable {
    public static var name: String {
        return String(reflecting: self.self)
    }
    public static func == (lhs: ServiceProvider, rhs: ServiceProvider) -> Bool {
        return  lhs.name == rhs.name
    }
}

extension ServiceProvider: Identifiable {
    
}

extension ServiceProvider {
    /// 启动时机
    public struct ProviderWhen: RawRepresentable, Comparable {
        public static func < (lhs: ProviderWhen, rhs: ProviderWhen) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        public let rawValue: Int
        /// 默认启动
        public static let eager = ProviderWhen(rawValue: 0)
        /// 窗口创建后启动
        public static let window = ProviderWhen(rawValue: 4)
        /// 主窗口后启动
        public static let root = ProviderWhen(rawValue: 8)
        
        public static func + (lhs: ProviderWhen, rhs: Int) -> ProviderWhen {
            return ProviderWhen(rawValue: lhs.rawValue + rhs)
        }
    }
}
