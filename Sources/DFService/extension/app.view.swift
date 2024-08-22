import SwiftUI

#if canImport(UIKit)
import UIKit
extension Space: View, UIViewRepresentable where Base: UIView {
    public func makeUIView(context: Context) -> Base {
        return base
    }

    public func updateUIView(_ uiView: Base, context: Context) {

    }

    public typealias UIViewType = Base
}
#elseif canImport(AppKit)
import AppKit

extension Space: View, NSViewRepresentable where Base: NSView {
    public func makeNSView(context: Context) -> Base {
        return base
    }

    public func updateNSView(_ nsView: Base, context: Context) {

    }

    public typealias NSViewType = Base
}
#else
extension Space: View where Base: View {
    public var body: Base {
        return base
    }

    public typealias Body = Base
}
#endif


public extension View {
    /// 链式操作
    func chain<Content: View>(
        @ViewBuilder transform: (Self) -> Content
    ) -> some View {
        transform(self)
    }
}
