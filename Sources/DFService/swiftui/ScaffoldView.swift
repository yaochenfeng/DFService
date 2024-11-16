import SwiftUI
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ScaffoldView<Content: View>: View {
    let content: Content
    let topBar: AnyView
    let bottomBar: AnyView

    public init<TopBar: View, BottomBar: View>(
        @ViewBuilder
        content: () -> Content,
        @ViewBuilder
        topBar: () -> TopBar,
        @ViewBuilder
        bottomBar: () -> BottomBar
    ) {
        self.content = content()
        self.topBar = AnyView(topBar())
        self.bottomBar = AnyView(bottomBar())
    }
    public init(
        @ViewBuilder
        content: () -> Content
    ) {
        self.content = content()
        self.topBar = AnyView(EmptyView())
        self.bottomBar = AnyView(EmptyView())
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Top bar
            topBar

            // Main content
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))

            // Bottom bar
            bottomBar
        }
        .edgesIgnoringSafeArea(.all) // Ignore safe areas if necessary
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ScaffoldView(content: {
            
        }, topBar: {
            
        }, bottomBar: {
            
        })
    }
}
