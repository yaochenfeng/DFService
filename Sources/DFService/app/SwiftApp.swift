import SwiftUI


public struct SwiftApp: App {
    public init() {
        DF.bootstrap(.eager)
    }
    public var body: some Scene {
        WindowGroup {
            SceneView(tag: "")
        }
    }
}

struct SceneView: View {
    let tag: String
    init(tag: String) {
        self.tag = tag
        DF.bootstrap(.window)
    }
    var body: some View {
        NavigationPage(router:  DF[RouteService.self, tag])
            .onAppear {
                DF.bootstrap(.splash)
            }
    }
}
