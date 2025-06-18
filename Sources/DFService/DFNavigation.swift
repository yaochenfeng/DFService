

public final class DFNavigation {
    var store = ServiceStore(state: State.init(root: Destination(route: "/"), paths: []))

    private var resultHandlers: [UUID: (Any?) -> Void] = [:]
    
    public struct State: DFStateType {
        var root: Destination
        var paths: [Destination]
        public static func reducer(state: DFNavigation.State, action: Action) -> DFNavigation.State? {
            var newState = state
            switch action {
            case .push(let destination):
                newState.paths.append(destination)
            case .pop:
                if(newState.paths.count > 0) {
                    newState.paths.removeLast()
                }
            case .setPath(let paths):
                newState.paths = paths
            }
            return newState
        }
        
        public static func effect(action: Action, context: ServiceStore<DFNavigation.State>.EffectContext) {
            
        }
        
        public enum Action {
            case push(Destination)
            case pop
            case setPath([Destination])
        }
    }
}

extension DFNavigation {
    public struct Destination: Hashable {
        public let route: String
        public let parameters: [String: Any]
        public let id: UUID

        public init(route: String, parameters: [String: Any] = [:], id: UUID = UUID()) {
            self.route = route
            self.parameters = parameters
            self.id = id
        }

        public static func ==(lhs: Destination, rhs: Destination) -> Bool {
            lhs.id == rhs.id
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}


import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    var navigation: DFNavigation {
        get { self[DFNavigationKey.self] }
        set { self[DFNavigationKey.self] = newValue }
    }
    
    struct DFNavigationKey: EnvironmentKey {
        typealias Value = DFNavigation
        
        static var defaultValue: Value = DFNavigation.init()
    }
}
