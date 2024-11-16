extension Bool: AppCompatible {}

public extension Space where Base == Bool {
    /// os ios
    static var iOS: Bool {
#if os(iOS)
        return true
#else
        return false
#endif
    }
    /// UIKit
    static var uikit: Bool {
#if canImport(UIKit)
        return true
#else
        return false
#endif
    }
}
