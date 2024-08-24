struct FactoryKey: Hashable {
    @usableFromInline let type: ObjectIdentifier
    @usableFromInline let key: String
    let name: ServiceName
    
    @inlinable
    @inline(__always)
    init(type: Any.Type, key: String = "", name: ServiceName = ServiceName("")) {
        self.type = ObjectIdentifier(type)
        self.key = key
        self.name = name
    }

    @inlinable
    @inline(__always)
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.type)
        hasher.combine(self.key)
    }

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type && lhs.key == rhs.key
    }

}
