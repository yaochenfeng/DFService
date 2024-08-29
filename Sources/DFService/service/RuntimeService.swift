public struct RuntimeService: DFServiceKey {
    public static var defaultValue: Value = Value()

    public struct Value {}
}

public extension RuntimeService.Value {
    var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    var isRunningInTests: Bool {
        #if canImport(XCTest)
        return true
        #else
        return false
        #endif
    }
}
