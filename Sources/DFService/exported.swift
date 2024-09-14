@_exported import SwiftUI


#if canImport(UIKit)
import UIKit
public typealias PlatformView = UIView
public typealias PlatformController = UIViewController

public protocol PlatformRepresentable: UIViewRepresentable {
    associatedtype PlatformView = UIViewType
    
    func makeView(context: Context) -> PlatformView
}

public extension PlatformRepresentable {
    func makeUIView(context: Context) -> PlatformView {
        return makeView(context: context)
    }
    
    func updateUIView(_ uiView: PlatformView, context: Context) {}
}
#elseif canImport(AppKit)
import AppKit

public typealias PlatformView = NSView
public typealias PlatformController = NSViewController

public protocol PlatformRepresentable: NSViewRepresentable {
    associatedtype PlatformView = NSViewType
    
    func makeView(context: Context) -> PlatformView
}

public extension PlatformRepresentable {
    func makeNSView(context: Context) -> PlatformView {
        makeView(context: context)
    }
    
    func updateNSView(_ nsView: PlatformView, context: Context) {}
}
#endif
