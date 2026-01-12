import WebKit
import SwiftUI

struct NFWebView: UIViewRepresentable {
    let url: String
    let onURLChange: (String) -> Void
    @Binding var isLoading: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self, onURLChange: onURLChange)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false

        if let requestUrl = URL(string: url) {
            webView.load(URLRequest(url: requestUrl))
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: NFWebView
        let onURLChange: (String) -> Void

        init(_ parent: NFWebView, onURLChange: @escaping (String) -> Void) {
            self.parent = parent
            self.onURLChange = onURLChange
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            if let urlString = navigationAction.request.url?.absoluteString {
                onURLChange(urlString)
            }
            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = true
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
        }

        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
        }
    }
}
