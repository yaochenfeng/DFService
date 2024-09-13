public extension Space where Base: AnyObject {
    /// 链式操作
        @discardableResult
        func then(_ block: (Base) throws -> Void) rethrows -> Base {
            try block(self.base)
            return self.base
        }
    /// 链式语法调用函数
        @discardableResult
        func chain(_ block: (Base) throws -> Void) rethrows -> Space<Base> {
            try block(base)
            return self
        }
}
