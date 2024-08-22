import Foundation

extension Space where Base == Bundle {
    /// 应用名 egg: Example
    public static var name: String {
        Bundle.main.app.getInfo("CFBundleName") ?? "unkown"
    }
    /// 应用名 egg: com.github.example
    public static var id: String {
        Bundle.main.app.getInfo("CFBundleIdentifier") ?? "unkown"
    }
    /// 版本 egg: 1.0.0
    public static var version: String {
        Bundle.main.app.getInfo("CFBundleShortVersionString") ?? "0.0.0"
    }

    /// build版本 egg:    1
    public static var buildVersion: String {
        Bundle.main.app.getInfo("CFBundleVersion") ?? "0.0"
    }
    
    /// 应用信息
    public func getInfo<T>(_ key: String) -> T? {
        guard let value = base.infoDictionary?[key] else {
            return nil
        }
        return BoxValue(value: value).optional()
    }
}

