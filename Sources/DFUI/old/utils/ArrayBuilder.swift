import Foundation

@resultBuilder
public struct ArrayBuilder<T> {
    public static func buildBlock(_ components: T...) -> [T] {
        return components
    }

    public static func buildOptional(_ component: [T]?) -> [T] {
        return component?.compactMap {$0} ?? []
    }

    public static func buildLimitedAvailability(_ component: [T]) -> [T] {
        return component
    }
    
    public static func buildEither(first component: [T]) -> [T] {
        return component
    }
    public static func buildEither(second component: [T]) -> [T] {
        return component
    }
    
    public static func buildBlock(_ components: [T]...) -> [T] {
        return components.reduce([T]()) { partialResult, value in
            return partialResult + value
        }
    }
}
