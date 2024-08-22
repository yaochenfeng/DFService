import Foundation

public struct Space<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// app命名空间
public protocol AppCompatible {
    associatedtype Base
    
    static var app: Space<Base>.Type { get set }

    var app: Space<Base> { get set }
}


extension AppCompatible {
    public static var app: Space<Self>.Type {
        get { Space<Self>.self }
        // swiftlint:disable:next unused_setter_value
        set { }
    }

    public var app: Space<Self> {
        get { Space(self) }
        // swiftlint:disable:next unused_setter_value
        set { }
    }
}

extension NSObject: AppCompatible {}
