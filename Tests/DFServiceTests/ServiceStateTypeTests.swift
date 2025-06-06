import XCTest

@testable import DFService

final class ServiceStateTypeTests: XCTestCase {
    let store = ServiceStore(state: CounterState(name: "demo"))
    func testExample() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        assert(store.state.name == "demo")
        store(.change("hello"))
        assert(store.state.name == "hello")
        print(store.state)

        store(.increment)
        assert(store.state.count == 1)
        store(.increment)
        assert(store.state.count == 2)
        store(.decrement)
        assert(store.state.count == 1)
    }
    // 测试异步加载数据
    func testAsyncLoadData() async throws {
        let expectation = XCTestExpectation(description: "Async data loading")
        store(.loadData)
        // 等待异步加载完成
        assert(self.store.state.isLoading == true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            assert(self.store.state.name == "AsyncName")
            assert(self.store.state.isLoading == false)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 2.0)
    }
}

struct CounterState: ServiceStateType {
    static func effect(action: Action, context: DFService.ServiceStore<CounterState>.EffectContext)
    {
        print("effect state:\(context.state) action:\(action)")
        switch action {
        case .loadData:

            context.dispatch(.setLoading(true))
            // 异步加载模拟
            Task {
                // 模拟异步操作，比如网络请求、文件加载等
                try await Task.sleep(nanoseconds: 1_000_000_000)  // 1秒延迟

                let fetchedName = "AsyncName"
                context.dispatch(.change(fetchedName))
                context.dispatch(.setLoading(false))
            }
        default: break
        }
    }

    var name = ""
    var count: Int = 0
    var isLoading: Bool = false

    static func reducer(state: Self, action: Action) -> Self? {
        var newValue = state
        switch action {
        case .change(let name):
            newValue.name = name
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

    enum Action {
        case change(String)
        case increment
        case decrement
        case loadData
        case setLoading(Bool)
    }
}
