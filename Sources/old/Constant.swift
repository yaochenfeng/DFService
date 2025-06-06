import Foundation

public struct Constant {
    #if canImport(UIKit)
    public static let isUIKit = true
    #else
    public static let isUIKit = false
    #endif
}
