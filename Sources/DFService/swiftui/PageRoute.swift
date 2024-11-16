//
//  SwiftUIView.swift
//  
//
//  Created by yaochenfeng on 2024/11/15.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PageRoute: View, Hashable {
    let page: AnyView
    let setting: RouteSetting
    public init<T: View>(
        @ViewBuilder builder: () -> T,
        setting: RouteSetting
    ) {
        self.page = AnyView(builder())
        self.setting = setting
    }
    public var body: some View {
        GeometryReader { proxy in
            page
        }
    }
    
    public static func == (lhs: PageRoute, rhs: PageRoute) -> Bool {
        lhs.setting.name == rhs.setting.name
        && String(describing: lhs.setting.argument) == String(describing: rhs.setting.argument)
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(setting.name)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension PageRoute: Identifiable {
    public var id: String {
        return setting.name
    }
}
