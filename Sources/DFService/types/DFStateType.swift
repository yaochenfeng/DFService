/// A protocol that defines the required interface for representing the state of a service.
/// Types conforming to `DFStateType` should encapsulate all necessary information
/// about the current state of a service, enabling state management and transitions.
public protocol DFStateType {
    associatedtype Action

    typealias Reducer = (_ state: Self, _ action: Action) -> Self?
    typealias Effect = (_ action: Action, _ context: ServiceStore<Self>.EffectContext) -> Void

    static func reducer(state: Self, action: Action) -> Self?
    static func effect(action: Action, context: ServiceStore<Self>.EffectContext)
}

