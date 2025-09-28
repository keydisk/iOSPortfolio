//
//  ImageDetailView.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/26/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import UIKit
import Kingfisher

public class ImageDetialView: UIScrollView {

    weak var imageView: UIImageView!
    public init(imageURL: String) {

        super.init(frame: .zero)

        maximumZoomScale = 3.0 // 최대 확대 배율
        minimumZoomScale = 1.0 // 최소 축소 배율
        bouncesZoom = true
        self.delegate = self

        let imageView = UIImageView()

        imageView.kf.setImage(with: URL(string: imageURL))
        imageView.contentMode = .scaleAspectFit

        addSubview(imageView)
        self.imageView = imageView

        imageView.snp.makeConstraints { m in

            m.width.equalTo(snp.width)
            m.edges.equalToSuperview()
        }
    }

    public init(image: UIImage) {

        super.init(frame: .zero)

        maximumZoomScale = 3.0 // 최대 확대 배율
        minimumZoomScale = 1.0 // 최소 축소 배율
        bouncesZoom = true
        self.delegate = self

        let imageView = UIImageView(image: image)
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
