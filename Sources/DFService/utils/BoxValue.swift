import Foundation


struct BoxValue {
    let value: Any

    func optional<T>() -> T? {
        if let v = value as? T {
            return v
        }
        return nil
    }

    func optional() -> String? {
        if let v = value as? CustomStringConvertible {
            return v.description
        }
        return nil
    }
}
