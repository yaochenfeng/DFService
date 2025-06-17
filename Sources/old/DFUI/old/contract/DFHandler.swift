public protocol DFHandler {
    associatedtype Input
    associatedtype Output = Void
    
    func handleSync(_ input: Input) throws -> Output
    func handle(_ input: Input) async throws-> Output
}

public extension DFHandler {
    func handle(_ input: Input) async throws -> Output {
        return try self.handleSync(input)
    }
}


public struct AnyHandler<Input,Output>: DFHandler {
    public func handleSync(_ input: Input) throws -> Output {
        return try _handlerSync(input)
    }
    public func handle(_ input: Input) async throws -> Output {
        return try await _handler(input)
    }
    
    private let _handlerSync:(Input) throws -> Output
    private let _handler:(Input) async throws -> Output
    public init<T: DFHandler>(_ handler: T) where T.Input == Input, T.Output == Output {
        self._handler = handler.handle(_:)
        self._handlerSync = handler.handleSync(_:)
    }
}


