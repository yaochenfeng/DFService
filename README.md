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


### 实现DFPromise 异步使用

`DFPromise` 提供了基于 Promise 的异步服务调用方式，适合需要链式调用或异步返回结果的场景。

#### 示例：异步获取数据

```swift
// 假设有一个异步获取用户信息的服务
struct UserInfo: Codable {
    let name: String
    let age: Int
}

// 定义一个 ServicePromise
let promise = DFPromise<UserInfo> { resolver in
    // 模拟异步网络请求
    Task {
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1秒延迟
        let user = UserInfo(name: "张三", age: 28)
        resolver.fulfill(user)
    }
}

// 使用 then 处理结果
promise.then { user in
    print("用户信息：\(user.name), 年龄：\(user.age)")
}.catch { error in
    print("获取失败：\(error)")
}
```

