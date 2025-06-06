# DFService

开发App常用工具和默认服务.


## 常用组件 ServiceValues管理常用服务
- 实现ServiceStateType 纯Swift Redux


### 实现ServiceStateType 使用

```swift
struct CounterState: ServiceStateType {
    enum Action {
        case increment
        case decrement
        case loadData
        case setLoading(Bool)
    }

    var name: String = ""
    var count: Int = 0
    var isLoading: Bool = false

    static func effect(action: Action, context: DFService.ServiceStore<CounterState>.EffectContext) {
        print("effect state:\(context.state) action:\(action)")
        switch action {
        case .loadData:
            context.dispatch(.setLoading(true))
            // 异步加载模拟
            Task {
                // 模拟异步操作，比如网络请求、文件加载等
                try await Task.sleep(nanoseconds: 1_000_000_000)  // 1秒延迟
                context.dispatch(.setLoading(false))
            }
        default:
            break
        }
    }

    static func reducer(state: Self, action: Action) -> Self? {
        var newValue = state
        switch action {
        case .increment:
            newValue.count += 1
        case .decrement:
            newValue.count -= 1
        case .loadData:
            return nil
        case .setLoading(let isLoading):
            newValue.isLoading = isLoading
        }
        return newValue
    }
}
```
