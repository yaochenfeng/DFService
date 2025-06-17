extension String: AppCompatible {}

public extension Space where Base == String {
    var url: URL? {
        if let url = URL(string: base) {
            return url
        } else if let str = base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: str) {
            return url
        }
        return nil
    }
}
