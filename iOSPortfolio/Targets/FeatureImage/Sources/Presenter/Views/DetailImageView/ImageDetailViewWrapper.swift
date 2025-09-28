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
import DesignSystem

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

public struct ImageDetailViewWrapper: UIViewRepresentable {

    let imageUrl: String

    public init(imageUrl: String) {

        self.imageUrl = imageUrl
    }

    public func makeUIView(context: Context) -> ImageDetialView {

        let imageDetail = ImageDetialView(imageURL: imageUrl)

        return imageDetail
    }

    public func updateUIView(_ uiViewController: ImageDetialView, context: Context) {
        // SwiftUI 상태 바뀔 때 업데이트 처리 필요시 여기에 작성
    }
}


