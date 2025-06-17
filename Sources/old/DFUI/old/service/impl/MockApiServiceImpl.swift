struct MockApiServiceImpl {
}



extension MockApiServiceImpl: DFApiCall {
    func callAsFunction(_ context: ApiCallConext) async throws -> Any {
        return ()
    }
}
