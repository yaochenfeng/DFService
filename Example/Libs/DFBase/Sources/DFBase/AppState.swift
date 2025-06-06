// The Swift Programming Language
// https://docs.swift.org/swift-book

import DFService
import SwiftUI


public struct AppState: ServiceStateType {
    public init() {}
    public var root: AnyView = AnyView(EmptyView())
    
    public static func reducer(state: AppState, action: Action) -> AppState? {
        var newState = state
        switch action {
            
        case .setRoot(let root):
            newState.root = root
        }
        return newState
    }
    
    public static func effect(action: Action, context: DFService.ServiceStore<AppState>.EffectContext) {
        
    }
    
    public enum Action {
        case setRoot(AnyView)
    }
    
    
}
