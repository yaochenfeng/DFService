import Foundation


open class ServiceStore<State: DFStateType> {

    public private(set) var state: State {
        didSet {
            stateChange()
        }
    }
    /// 状态变更监听：iOS 12 用这个
    public var onStateChange: ((State) -> Void)?

    private let reducer: State.Reducer
    private let effect: (State.Action, EffectContext) -> Void
    private let lock = NSLock()

    public init(
        state: State,
        reducer: @escaping State.Reducer = State.reducer,
        effect: @escaping State.Effect = State.effect
    ) {
        self.state = state
        self.reducer = reducer
        self.effect = effect
    }

}

extension ServiceStore {
    /// 分发 Action，使用 reducer 更新状态
    public func dispatch(_ action: State.Action) {
        lock.lock()
        let oldState = state
        let result = reducer(state, action)
        if let newState = result {
            self.state = newState
        }
        lock.unlock()
        let context = EffectContext(
            getState: { [weak self] in self?.state ?? oldState },
            dispatch: { [weak self] in self?.dispatch($0) }
        )
        effect(action, context)
    }

    /// 支持 callAsFunction 语法糖：store(action)
    public func callAsFunction(_ action: State.Action) {
        dispatch(action)
    }

    public struct EffectContext {
        fileprivate let getState: () -> State
        fileprivate let dispatch: (State.Action) -> Void

        public init(getState: @escaping () -> State, dispatch: @escaping (State.Action) -> Void) {
            self.getState = getState
            self.dispatch = dispatch
        }

        public var state: State {
            return getState()
        }

        public func dispatch(_ action: State.Action) {
            dispatch(action)
        }
    }

}

#if canImport(Combine)
    import Combine
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    extension ServiceStore: ObservableObject {
    }
#endif
extension ServiceStore {
    private func stateChange() {
        #if canImport(Combine)
            if #available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *) {
                self.objectWillChange.send()
            }
        #endif
        self.onStateChange?(self.state)
    }
}
