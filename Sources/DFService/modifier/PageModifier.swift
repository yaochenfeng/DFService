import SwiftUI

public enum PageAction: Equatable {
    case none
    case setTitle(String?)
}
struct PageModifier: ViewModifier {
    let action: PageAction
    public func body(content: Content) -> some View {
        content
            .preference(key: PageActionKey.self, value: action)
    }
}

struct PageActionKey: PreferenceKey {
    public static func reduce(value: inout PageAction, nextValue: () -> PageAction) {
        value = nextValue()
    }
    public static var defaultValue = PageAction.none
}


public extension View {
    func pageAction(_ action: PageAction) -> some View {
        self.modifier(PageModifier(action: action))
    }
}
