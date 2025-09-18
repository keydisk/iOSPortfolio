//
//  WebView.swift
//  View
//
//  Created by JuYoung choi on 7/22/25.
//

import SwiftUI
import SnapKit
import WebKit


import Combine


/// 웹뷰 UIKit 랩핑
struct SUWKWebView: UIViewRepresentable {
    
    typealias UIViewType = CustomWebView
    let url: String
    @Binding var webViewTitle: String
    
    init(url: String, webViewTitle: Binding<String>) {
        
        self.url = url
        print("webview url : \(self.url)")
        _webViewTitle = webViewTitle
    }
    
    func makeUIView(context: Context) -> UIViewType {
        // Return MyViewController instance
        let webView = CustomWebView(loadingFinishCallBack: {title in
            guard title.isEmpty == false else {
                return
            }
            
            webViewTitle = title
        })
        
        webView.requestUrl(requestUrl: self.url)
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Self.Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
        
    }
}

/// progressBar 추가 된 웹뷰
class CustomWebView: WKWebView {

    deinit {
        self.removeObserver(self, forKeyPath: loadingEstimatedProgress)
    }
    
    let loadingEstimatedProgress = "estimatedProgress"
    weak var progressBar: UIProgressView?
    var titleCallBack: ((String) -> Void)?
    
    init(loadingFinishCallBack: @escaping (String) -> Void ) {
        let config = WKWebViewConfiguration()
        config.mediaTypesRequiringUserActionForPlayback = []
        config.allowsInlineMediaPlayback = true
        
        super.init(frame: .zero, configuration: config)
        
        titleCallBack = loadingFinishCallBack
        drawProgressBar()
        
        self.navigationDelegate = self
        self.configuration.websiteDataStore = WKWebsiteDataStore.default()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 프로그래스 바 그리기
    private func drawProgressBar() {
        
        guard progressBar == nil else {
            return
        }
        
        let progressBar = UIProgressView()
        
        self.addSubview(progressBar)
        self.progressBar = progressBar
        
        progressBar.progressTintColor = .rgb(0, 163, 46)
        progressBar.trackTintColor    = .rgba(180, 180, 180, 50)
        progressBar.progressViewStyle = .default
        
        progressBar.snp.makeConstraints({m in
            m.leading.top.equalToSuperview()
            m.width.equalToSuperview()
            m.height.equalTo(3)
        })
        
        progressBar.progress = 0
        
        self.bringSubviewToFront(progressBar)
        self.addObserver(self, forKeyPath: loadingEstimatedProgress, options: .new, context: nil) // add observer for key path
    }
    
    /// URL 인코딩을 위해 호출
    private func getUrl(_ url: String, urlEncoding: Bool = true) -> URL? {
        
        if urlEncoding {
            var requestUrlText: String = ""
            
            if(url.hasPrefix("http") == false ) {
                
                requestUrlText = requestUrlText.appending(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            } else {
                
                requestUrlText = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
            }
            
            let requestUrl = URL(string: requestUrlText)
            return requestUrl
        } else {
            let requestUrl = URL(string: url)
            return requestUrl
        }
    }
    
    /// 웹페이지 로딩
    public func requestUrl(requestUrl: String, ignoreCache: Bool = false, urlEncoding: Bool = true) {
        
        guard let url = URL(string: requestUrl) else {
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: (ignoreCache ? .reloadIgnoringLocalCacheData : .useProtocolCachePolicy) , timeoutInterval: 20)
        request.httpShouldHandleCookies = true
        
        if let navigation:WKNavigation = self.load(request) { // 정확한 역할 찾아보기
            
            debugPrint("\(navigation)");
        }
        
    }
    
    /// 웹뷰 로딩 상태를 보여주기 위해 적용
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == loadingEstimatedProgress else {
            super.observeValue(forKeyPath:keyPath, of: object, change: change, context: context)
            return
        }
        
        if self.estimatedProgress < 1  {
            
            self.drawProgressBar()
            self.progressBar?.isHidden = false
            
            let progress = Float(self.estimatedProgress)
            if self.progressBar?.progress ?? 0 > progress {
                self.progressBar?.progress = progress
            } else {
                self.progressBar?.setProgress(progress, animated: true)
            }
        } else {
            
            self.progressBar?.progress = 0
            
            UIView.animate(withDuration: 0.3, animations: {[weak self] () in
                self?.progressBar?.alpha = 1.0
            }, completion: {[weak self] _ in
                self?.progressBar?.isHidden = true
            })
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        print("didFailProvisionalNavigation : \(error.localizedDescription) error.asAFError?.responseCode : \((error as NSError).code)")
    }
    
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.useCredential, nil)
            return
        }
        
        DispatchQueue.main.async {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
    }
    
    func webView(_ webView: WKWebView,  navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
    
        if navigationResponse.canShowMIMEType {
            
            decisionHandler(.allow)
        } else {
            decisionHandler(.download)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
    }
}

extension CustomWebView: WKNavigationDelegate {
    
    /// 타이틀 적용을 위해 사용
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        titleCallBack?( webView.title ?? "")
    }
}
