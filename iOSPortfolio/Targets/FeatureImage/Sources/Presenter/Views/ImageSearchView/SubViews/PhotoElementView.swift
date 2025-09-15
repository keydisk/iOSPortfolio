//
//  PhotoElementView.swift
//  FeatureImage
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import SwiftUI
import DesignSystem
import Kingfisher

struct PhotoElementView: View {

    let element: ImageElement
    @State var isElementLoaded = false
    @State var isFailed = false

    private var thumbnailView: some View {
        GeometryReader { geometry in
            KFImage(element.thumbnailURL)
                .onFailure { _ in
                    isFailed = true
                }
                .onSuccess { _ in
                    isElementLoaded = true
                }
                .placeholder {
                    ZStack {
                        if isFailed == false {
                            Image(systemName: "tray")

                            ProgressView("loading...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(.secondary)
                                        .padding(-5)
                                )
                        } else {
                            Image(systemName: "exclamationmark.warninglight")
                        }
                    }
                }
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.width * 4 / 3)
                .clipped()
                .maskingCornerRadius(6)
                .onTapGesture {

                }
        }
        .aspectRatio(3 / 4, contentMode: .fit)
    }

    private func setText(text: String) -> some View {
        HStack {
            Text(text)
                .lineLimit(1)
            Spacer()
        }
    }

    var body: some View {
        VStack {
            thumbnailView

            setText(text: element.printTitle)
            if let printDate = element.printDate {
                setText(text: printDate)
            }


        }
    }
}

//#Preview {
//    PhotoElementView()
//}
