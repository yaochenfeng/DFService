import SwiftUI

public struct PageLayout<Content: View>: View {
    var bar: PageBar? = nil
    let content: Content
    public var body: some View {
        VStack(spacing: 0) {
            if let pageBar = bar {
                pageBar
            }
            
            content
            
            Spacer()
        }
        .chain { view in
#if os(macOS)
            view
#else
            view.navigationBarHidden(bar != nil)
#endif
        }
        
    }
    
    public init(@ViewBuilder
                content: () -> Content) {
        self.content = content()
    }
    
    public func pagBar(_ builder: () -> PageBar?) -> Self {
        var clone = self
        clone.bar = builder()
        return clone
    }
    
    public func pagBar(title: String,
                       backgroundColor: Color = .white,
                       showBack: Bool = true) -> Self {
        var clone = self
        clone.bar = PageBar(title,
                            backgroundColor: backgroundColor,showBack: showBack)
        return clone
    }
}

struct PageLayout_Previews: PreviewProvider {
    static var previews: some View {
        PageLayout {
            Text("hello")
        }.pagBar {
            return .init("标题", backgroundColor: .red)
        }

    }
}
