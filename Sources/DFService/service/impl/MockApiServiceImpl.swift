struct MockApiServiceImpl {
}



extension MockApiServiceImpl: DFApiCall {
    func callAsFunction(_ context: ApiCallConext) async throws -> Any {
        Application.shared[LogService.self].debug("api 未实现 \(context.method):\(context.param)")
        return ()
    }
}
