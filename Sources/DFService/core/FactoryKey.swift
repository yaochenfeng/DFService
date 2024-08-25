struct FactoryKey: Hashable {
    @usableFromInline let type: Any.Type
    @usableFromInline let tag: String
    @usableFromInline let identifier: ObjectIdentifier
    
    @inlinable
    @inline(__always)
    init(type: Any.Type, tag: String = "") {
        self.type = type
        self.tag = tag
        self.identifier = ObjectIdentifier(type)
    }

    @inlinable
    @inline(__always)
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
        hasher.combine(self.tag)
    }

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.tag == rhs.tag
    }

}
