import DFService

struct NavPathStack: DFStateType {
    var root: NavDestination
    var paths = [NavDestination]()

    static func reducer(state: NavPathStack, action: Action) -> NavPathStack? {
        var newState = state

        switch action {
        case .setPath(let list):
            newState.paths = list
        case .navigate(let value):
            newState.paths.append(value)
        case .back:
            if !newState.paths.isEmpty {
                newState.paths.removeLast()
            }
        case .backToRoot:
            newState.paths.removeAll()
        case .setRoot(let value):
            newState.paths.removeAll()
            newState.root = value
            newState.root.info.isEntry = true
        }
        return newState
    }

    static func effect(action: Action, context: DFService.ServiceStore<NavPathStack>.EffectContext)
    {

    }

    enum Action {
        case setPath([NavDestination])
        case navigate(NavDestination)
        case setRoot(NavDestination)
        case back
        // 返回首页
        case backToRoot
    }
    
    /// 判断当前路由路径
      public var current: NavDestination {
          paths.last ?? root
      }
}
