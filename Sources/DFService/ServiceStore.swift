import Combine

public final class ServiceStore<State: ServiceStateType> {
    public private(set) var state: State

    private let reducer: State.Reducer

    public init(
        state: State,
        reducer: @escaping State.Reducer = State.reducer
    ) {
        self.state = state
        self.reducer = reducer
    }

    /// 分发 Action，使用 reducer 更新状态
    @discardableResult
    public func send(_ action: State.Action) -> State {
        let newState = reducer(state, action)
        state = newState
        return newState
    }

    /// 支持 callAsFunction 语法糖：store(action)
    @discardableResult
    public func callAsFunction(_ action: State.Action) -> State {
        send(action)
    }
}
