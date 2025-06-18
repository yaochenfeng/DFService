import Foundation
import SwiftUI

public struct NavPathInfo {
    public let name: String
    public let param: JSONValue
    public var isEntry: Bool
    public init(name: String, param: JSONValue = [:], isEntry: Bool = false) {
        self.name = name
        self.param = param
        self.isEntry = isEntry
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct NavDestination: Hashable, View {
    public let id: UUID
    public let info: NavPathInfo
    public let page: AnyView

    public init<T: View>(id: UUID = UUID(), info: NavPathInfo, @ViewBuilder builder: (NavPathInfo) -> T) {
        self.info = info
        self.id = id
        self.page = AnyView(builder(info))
        
    }

    public static func ==(lhs: NavDestination, rhs: NavDestination) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    public var body: some View {
        return page
    }
}
