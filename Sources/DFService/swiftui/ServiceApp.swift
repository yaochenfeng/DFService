import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ServiceApp: App {
    let container = ServiceContainer.shared
    public init() {
        LogService.service.info("应用启动")
    }
    public var body: some Scene {
        WindowGroup {
            Text("暂无实现")
                .padding()
        }
    }
}
