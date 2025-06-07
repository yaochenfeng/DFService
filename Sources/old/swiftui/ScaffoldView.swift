import SwiftUI
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ScaffoldView<Content: View>: View {
    let content: Content
    let topBar: AnyView
    let bottomBar: AnyView
    let backgroundColor: Color
    
    public init(
        @ViewBuilder
        content: () -> Content,
        @ViewBuilder
        topBar: () -> any View = {
            EmptyView()
        },
        @ViewBuilder
        bottomBar: () -> any View = {
            EmptyView()
        },
        backgroundColor: Color = .white
    ) {
        self.content = content()
        self.topBar = AnyView(topBar())
        self.bottomBar = AnyView(bottomBar())
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Top bar
            topBar
            
            // Main content
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
            
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
