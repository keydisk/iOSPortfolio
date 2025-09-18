//
//  ImageDetailViewWrapper.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/18/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import SwiftUI
import UIKit
import SnapKit

struct ImageDetailView: View {

    let imageUrl: String
    let cooridnator: any ImageSearchCoordinator

    init(imageUrl: String, coordi: (any ImageSearchCoordinator) ) {

        self.imageUrl = imageUrl
        cooridnator = coordi
    }

    var body: some View {
        VStack {

            ImageDetailViewWrapper(imageUrl: imageUrl )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.backward")
                        .imageScale(.medium)
                    Text("홈")
                }
                .accessibilityIdentifier("imageDetailViewBackBtn")
                .onTapGesture {
                    cooridnator.pop()
                }
            }
        }
        .accessibilityIdentifier("imageDetailView")
    }


}

struct ImageDetailViewWrapper: UIViewRepresentable {

    let imageUrl: String

    init(imageUrl: String) {

        self.imageUrl = imageUrl
    }

    func makeUIView(context: Context) -> ImageDetialView {

        let imageDetail = ImageDetialView(imageURL: imageUrl)

        return imageDetail
    }

    func updateUIView(_ uiViewController: ImageDetialView, context: Context) {
        // SwiftUI 상태 바뀔 때 업데이트 처리 필요시 여기에 작성
    }
}


class ImageDetialView: UIScrollView {

    let imgUrl: String
    weak var imageView: UIImageView!
    init(imageURL: String) {

        imgUrl = imageURL

        super.init(frame: .zero)

        maximumZoomScale = 3.0 // 최대 확대 배율
        minimumZoomScale = 1.0 // 최소 축소 배율
        bouncesZoom = true
        self.delegate = self

        let imageView = UIImageView()

        imageView.kf.setImage(with: URL(string: imgUrl))
        imageView.contentMode = .scaleAspectFit

        addSubview(imageView)
        self.imageView = imageView

        imageView.snp.makeConstraints { m in

            m.width.equalTo(snp.width)
            m.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension ImageDetialView: UIScrollViewDelegate {

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        self.imageView
    }
}
