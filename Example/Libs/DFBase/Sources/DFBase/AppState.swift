// The Swift Programming Language
// https://docs.swift.org/swift-book

import DFService
import SwiftUI

public struct AppState:  ServiceStateType {
    public init() {}
    public var root: AnyView = AnyView(EmptyView())

    nonisolated public static func reducer(state: AppState, action: Action) -> AppState? {
        var newState = state
        switch action {

        case .setRoot(let root):
            newState.root = root
        }
        return newState
    }

    public static func effect(
        action: Action, context: DFService.ServiceStore<AppState>.EffectContext
    ) {

    }

    public enum Action {
        case setRoot(AnyView)
    }

    @MainActor public static var shared = AppState()
}

extension EnvironmentValues {
    public var appStore: ServiceStore<AppState> {
            get { self[AppStoreKey.self] }
            set { self[AppStoreKey.self] = newValue }
        }

}

private struct AppStoreKey {
    @MainActor
    static var defaultValue: ServiceStore<AppState> {
        return ServiceStore(state: .shared)
    }
}

#if swift(>=5.8)
extension AppStoreKey: @preconcurrency EnvironmentKey {
}
#else
extension AppStoreKey: EnvironmentKey {
}
#endif
