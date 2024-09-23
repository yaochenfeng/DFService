import SwiftUI

public struct WebPage: View {
    public init(_ request: URLRequest?) {
        self.request = request
    }
    @StateObject
    var controller = WebController()
    let request: URLRequest?
    public var body: some View {
        ZStack(alignment: .topLeading) {
            WebView(request, controller: controller)
            
            ProgressView(value: controller.progress)
                .progressViewStyle(.linear)
        }
        .navigationTitle(Text(controller.title ?? ""))
    }
}
public extension WebPage {
    init(_ string: String) {
        if let url = string.app.url {
            self.init(URLRequest(url: url))
        } else {
            self.init(nil)
        }
    }
}

struct WebPage_Previews: PreviewProvider {
    static var previews: some View {
        WebPage("https://m.baidu.com")
    }
}
