import SwiftUI

public struct WebPage: View {
    let request: RouteRequest
    public init(_ request: RouteRequest) {
        self.request = request
    }
    @StateObject
    var controller = WebController()
    
    public var body: some View {
        PageLayout {
            ZStack(alignment: .topLeading) {
                if let url = request.url {
                    WebView(URLRequest(url: url), controller: controller)
                }
                if controller.progress != 1 {
                    ProgressView(value: controller.progress)
                        .progressViewStyle(.linear)
                }
            }
        }.pagBar {
            PageBar(controller.title ?? "")
        }
    }
}
public extension WebPage {
    init(_ string: String) {
        if let url = string.app.url {
            self.init(.init(url: url))
        } else {
            self.init(.init(action: .empty))
        }
    }
}

struct WebPage_Previews: PreviewProvider {
    static var previews: some View {
        WebPage("https://m.baidu.com")
    }
}
