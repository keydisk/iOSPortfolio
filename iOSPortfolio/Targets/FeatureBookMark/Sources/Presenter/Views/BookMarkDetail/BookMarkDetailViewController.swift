//
//  BookMarkDetailViewController.swift
//  FeatureBookMark
//
//  Created by JuYoung choi on 9/18/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import UIKit
import SnapKit
import Core

class BookMarkDetailViewController: UIViewController {

    let url: String
    var coordinator : (any BookMarkCoordinator)?
    weak var webView: CustomWebView?

    init(url: String, coordinator: any BookMarkCoordinator) {

        self.url = url
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func drawUI() {
        let appearance = UINavigationBarAppearance()

        appearance.configureWithOpaqueBackground()

        appearance.backgroundColor = .white

        appearance.shadowColor = .clear

        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.compactAppearance = appearance

        let webView = CustomWebView(loadingFinishCallBack: {[weak self] title in
            guard title.isEmpty == false else {
                return
            }

            self?.navigationItem.title = title.removingPercentEncoding
        })

        webView.requestUrl(requestUrl: url)
        view.addSubview(webView)
        self.webView = webView

        webView.snp.makeConstraints { (m) in

            m.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            m.leading.trailing.equalToSuperview()
            m.bottom.equalToSuperview()
        }

        let backButtonImage = UIImage(systemName: "chevron.backward")

        let backButton = UIBarButtonItem(image: backButtonImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))

        backButton.tintColor = .black

        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        // 4. ViewController가 직접 pop을 호출하는 대신, Coordinator에게 요청합니다.
        if webView?.canGoBack == true {
            webView?.goBack()
        } else {
            coordinator?.pop()
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawUI()
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
