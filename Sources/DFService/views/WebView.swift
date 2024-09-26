
import SwiftUI
open class WebController: ObservableObject {
    public init() {}
    
    let config = WKWebViewConfiguration().app.then { config in
        config.websiteDataStore = .default()
    }
    
    @Published
    public var progress: Double = 0
    @Published
    public var title: String? = nil
    @Published
    public var isLoading = false
    
}
import WebKit

public struct WebView: PlatformRepresentable {
    let controller: WebController
    let request: URLRequest?
    
    public init(_ request: URLRequest?,
         controller: WebController = WebController()) {
        self.request = request
        self.controller = controller
    }
    public func makeView(context: Context) -> WKWebView {
        let web = context.coordinator.webView
        if let req = request {
            DispatchQueue.main.async {
                web.load(req)
            }
        }
        return web
    }
    public func makeCoordinator() -> Coordinator {
        return Coordinator(controller)
    }
}

public extension WebView {
    init(_ string: String) {
        if let url = string.app.url {
            self.init(URLRequest(url: url))
        } else {
            self.init(nil)
        }
    }
}

public extension WebView {
    class Coordinator: NSObject {
        let controller: WebController
        let webView: WKWebView
        
        @Injected(LogService.self)
        var logger
        required init(_ controller: WebController) {
            self.controller = controller
            self.webView = WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1), configuration: controller.config)
            super.init()
            makeObserve()
        }
    }
}

extension WebView.Coordinator {
    func makeObserve() {
        webView.publisher(for: \.estimatedProgress)
            .receive(on: DispatchQueue.main)
            .assign(to: &controller.$progress)
        webView.publisher(for: \.isLoading)
            .receive(on: DispatchQueue.main)
            .assign(to: &controller.$isLoading)
        
        webView.publisher(for: \.title)
            .receive(on: DispatchQueue.main)
            .assign(to: &controller.$title)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
}

extension WebView.Coordinator: WKUIDelegate {
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        logger.info(navigation.debugDescription)
    }
}
extension WebView.Coordinator: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        logger.info(navigationAction.debugDescription)
        guard let scheme = navigationAction.request.url?.scheme else {
            return .cancel
        }
        guard scheme.contains("http") else {
            return .cancel
        }
        if #available(macOS 11.3, iOS 14.5, *), navigationAction.shouldPerformDownload {
            return .download
        }
        return .allow
    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        logger.info(navigationResponse.debugDescription)
        return .allow
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView("https://m.baidu.com")
    }
}
