//
//  WebView.swift
//  View
//
//  Created by JuYoung choi on 7/19/25.
//
import SwiftUI
import SnapKit
import WebKit
import Combine
import DesignSystem

/// 웹뷰
public struct SUWebView: View {
    let url: String
    @Environment(\.dismiss) private var dismiss
    /// 웹뷰에서 가져온 타이틀 적용을 위해 사용
    @State var webViewTitle = ""

    public init(url: String, webViewTitle: String = "") {
        self.url = url
        self.webViewTitle = webViewTitle
    }

    public var body: some View {
        VStack {
            SUWKWebView(url: url, webViewTitle: $webViewTitle)
                .accessibilityIdentifier("testWebView")
        }
        .navigationBarBackButtonHidden(true) // 시스템 기본 백버튼 숨김
    }
}

/// 웹뷰 UIKit 랩핑
struct SUWKWebView: UIViewRepresentable {
    typealias UIViewType = CustomWebView
    let url: String
    @Binding var webViewTitle: String

    init(url: String, webViewTitle: Binding<String>) {
        self.url = url
        _webViewTitle = webViewTitle
    }

    func makeUIView(context _: Context) -> UIViewType {
        // Return MyViewController instance
        let webView = CustomWebView(loadingFinishCallBack: { title in
            guard title.isEmpty == false else {
                return
            }

            webViewTitle = title
        })

        return webView
    }

    func updateUIView(_ uiView: UIViewType, context _: Self.Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
        uiView.requestUrl(requestUrl: url)
    }
}

/// progressBar 추가 된 웹뷰
class CustomWebView: WKWebView {
    
    let loadingEstimatedProgress = "estimatedProgress"
    weak var progressBar: UIProgressView?
    var titleCallBack: ((String) -> Void)?

    init(loadingFinishCallBack: @escaping (String) -> Void) {
        super.init(frame: .zero, configuration: WKWebViewConfiguration())

        titleCallBack = loadingFinishCallBack
        drawProgressBar()
        navigationDelegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 프로그래스 바 그리기
    private func drawProgressBar() {
        guard progressBar == nil else {
            return
        }

        let progressBar = UIProgressView()

        addSubview(progressBar)
        self.progressBar = progressBar

        progressBar.progressTintColor = .rgb(0, 163, 46)
        progressBar.trackTintColor = .rgba(180, 180, 180, 50)
        progressBar.progressViewStyle = .default

        progressBar.snp.makeConstraints { constraint in
            constraint.leading.top.equalToSuperview()
            constraint.width.equalToSuperview()
            constraint.height.equalTo(3)
        }

        progressBar.progress = 0

        bringSubviewToFront(progressBar)
        addObserver(self, forKeyPath: loadingEstimatedProgress, options: .new, context: nil) // add observer for key path
    }

    /// URL 인코딩을 위해 호출
    private func getUrl(_ url: String, urlEncoding: Bool = true) -> URL? {
        if urlEncoding {
            var requestUrlText = ""

            if url.hasPrefix("http") == false {
                requestUrlText = requestUrlText.appending(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            } else {
                requestUrlText = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }

            let requestUrl = URL(string: requestUrlText)
            return requestUrl
        } else {
            let requestUrl = URL(string: url)
            return requestUrl
        }
    }

    /// 웹페이지 로딩
    func requestUrl(requestUrl: String, ignoreCache: Bool = false, urlEncoding: Bool = true) {
        guard let url = getUrl(requestUrl, urlEncoding: urlEncoding) else {
            return
        }

        var request = URLRequest(url: url, cachePolicy: ignoreCache ? .reloadIgnoringLocalCacheData : .useProtocolCachePolicy, timeoutInterval: 20)
        request.httpShouldHandleCookies = true

        if let navigation: WKNavigation = load(request) { // 정확한 역할 찾아보기

            debugPrint("\(navigation)")
        }
    }

    /// 웹뷰 로딩 상태를 보여주기 위해 적용
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == loadingEstimatedProgress else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }

        if estimatedProgress < 1 {
            drawProgressBar()
            progressBar?.isHidden = false

            let progress = Float(estimatedProgress)
            if progressBar?.progress ?? 0 > progress {
                progressBar?.progress = progress
            } else {
                progressBar?.setProgress(progress, animated: true)
            }
        } else {
            progressBar?.progress = 0

            UIView.animate(withDuration: 0.3, animations: { [weak self] () in
                self?.progressBar?.alpha = 1.0
            }, completion: { [weak self] _ in
                self?.progressBar?.isHidden = true
            })
        }
    }
}

extension CustomWebView: WKNavigationDelegate {
    /// 타이틀 적용을 위해 사용
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        titleCallBack?(webView.title ?? "")
    }
}
