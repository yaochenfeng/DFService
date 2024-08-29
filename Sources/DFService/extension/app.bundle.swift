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
  /// 加载类
  public func loadClass<T: AnyObject>(ofType type: T.Type,
                                      named name: String? = nil) throws -> T.Type {
    var name = name ?? String(reflecting: type.self)
    if name.components(separatedBy: ".").count == 1,
       let namespace: String = base.infoDictionary?["CFBundleExecutable"] as? String {
        name = namespace.replacingOccurrences(of: " ", with: "_") + "." + name
    }
    guard name.components(separatedBy: ".").count > 1 else {
      throw CommonError.notFound("module")
    }
    guard let loadedClass = base.classNamed(name) else { throw CommonError.notFound(type) }
    guard let castedClass = loadedClass as? T.Type else {
      throw CommonError.convert(from: String(describing: loadedClass), to: name)
    }

    return castedClass
  }
}
