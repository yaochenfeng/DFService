#if canImport(UIKit)
import UIKit
#endif
public struct RuntimeService: DFServiceKey {
    public static var defaultValue: Value = Value()

    public struct Value {}
    
    private static var uuid: String?
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
    
    var deviceName: String {
        #if canImport(UIKit)
        return UIDevice.current.model
        #else
        return "unkown"
        #endif
    }
    /// 设备id
    var genDeviceId: String {
        if let value = RuntimeService.uuid {
            return value
        }
#if canImport(UIKit)
        let value = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
#else
        let value = UUID().uuidString
#endif
        RuntimeService.uuid = value
        return value
       
    }
}

public extension Application {
    var runtime: RuntimeService.Value {
        return self[RuntimeService.self]
    }
}
