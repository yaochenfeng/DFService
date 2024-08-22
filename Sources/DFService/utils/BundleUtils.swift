import Foundation

extension Bundle {
    func loadClass<T: AnyObject>(ofType type: T.Type, named name: String? = nil) throws -> T.Type {
        var name = name ?? String(reflecting: type.self)
        if name.components(separatedBy: ".").count == 1,
            let namespace: String = infoDictionary?["CFBundleExecutable"] as? String {
            name = namespace.replacingOccurrences(of: " ", with: "_") + "." + name
        }
        guard name.components(separatedBy: ".").count > 1 else { throw ClassLoadError.moduleNotFound }
        guard let loadedClass = classNamed(name) else { throw ClassLoadError.classNotFound }
        guard let castedClass = loadedClass as? T.Type else { throw ClassLoadError.invalidClassType(loaded: name, expected: String(describing: type)) }

        return castedClass
    }
}

extension Bundle {
    enum ClassLoadError: Error {
        case moduleNotFound
        case classNotFound
        case invalidClassType(loaded: String, expected: String)
    }
}
