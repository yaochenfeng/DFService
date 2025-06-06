public protocol ServiceStateType {
    associatedtype Action
    typealias Reducer = (_ state: Self, _ action: Action) -> Self?
    typealias Effect = (_ action: Action, _ context: ServiceStore<Self>.EffectContext) -> Void
    /// 默认action reducer实现
    static func reducer(state: Self, action: Action) -> Self?
    static func effect(action: Action, context: ServiceStore<Self>.EffectContext) -> Void
}
