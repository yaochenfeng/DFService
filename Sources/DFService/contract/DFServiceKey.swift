import SwiftUI
public protocol DFServiceKey {
    associatedtype Value
    static var defaultValue: Self.Value { get }
}
