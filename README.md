# DFService

开发App常用工具和默认服务.


## 常用协议
- DFApplication 应用

## 命名空间 app
- UIView/NSView 转SwiftUI View

需要拓展，例如

```Swift

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
```
