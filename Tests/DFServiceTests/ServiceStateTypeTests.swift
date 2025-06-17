import XCTest

@testable import DFService

final class ServiceStateTypeTests: XCTestCase {
    let store = ServiceStore(state: CounterState(name: "demo"))
    
    func testInitialState() {
        let initialState = CounterState(name: "init", count: 5, isLoading: false)
        XCTAssertEqual(initialState.name, "init")
        XCTAssertEqual(initialState.count, 5)
        XCTAssertFalse(initialState.isLoading)
    }

    func testReducerChangeName() {
        let state = CounterState(name: "old", count: 0, isLoading: false)
        let newState = CounterState.reducer(state: state, action: .change("new"))
        XCTAssertEqual(newState?.name, "new")
        XCTAssertEqual(newState?.count, 0)
    }

    func testReducerIncrementDecrement() {
        var state = CounterState(name: "test", count: 0, isLoading: false)
        state = CounterState.reducer(state: state, action: .increment)!
        XCTAssertEqual(state.count, 1)
        state = CounterState.reducer(state: state, action: .decrement)!
        XCTAssertEqual(state.count, 0)
    }

    func testReducerSetLoading() {
        let state = CounterState(name: "test", count: 0, isLoading: false)
        let newState = CounterState.reducer(state: state, action: .setLoading(true))
        XCTAssertTrue(newState?.isLoading ?? false)
    }

    func testReducerLoadDataReturnsNil() {
        let state = CounterState(name: "test", count: 0, isLoading: false)
        let result = CounterState.reducer(state: state, action: .loadData)
        XCTAssertNil(result)
    }

   
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

struct CounterState: DFStateType {
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
