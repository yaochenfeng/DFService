import XCTest
@testable import DFService
final class ServiceStateTypeTests: XCTestCase {
    let store = ServiceStore(state: CounterState(name: "demo"))
    func testExample() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        assert(store.state.name == "demo")
        
        assert(store(.change("hello")).name == "hello")
        assert(store.state.name == "hello")
        print(store.state)
    }
    
}


struct CounterState: ServiceStateType {
    var name = ""
    var count: Int = 0
    
    static func reducer(state: Self, action: Action) -> Self {
        var newValue = state
        switch action {
        case .change(let name):
            newValue.name = name
        case .increment:
            newValue.count += 1
        case .decrement:
            newValue.count += 1
        }
        return newValue
    }
    
    enum Action {
        case change(String)
        case increment
        case decrement
    }
}
