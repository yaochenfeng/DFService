import Foundation

extension DF {
    public static let runtime = Runtime()
    
    public struct Runtime {
        
    }
}
public extension DF.Runtime {
    var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
