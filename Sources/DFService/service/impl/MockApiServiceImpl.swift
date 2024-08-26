struct MockApiServiceImpl {
}



extension MockApiServiceImpl: DFApiCall {
    func callAsFunction(_ context: ApiCallConext) async throws -> Any {
        ServiceValues[LogService.self].debug("api 未实现 \(context)")
        return ()
    }
}
