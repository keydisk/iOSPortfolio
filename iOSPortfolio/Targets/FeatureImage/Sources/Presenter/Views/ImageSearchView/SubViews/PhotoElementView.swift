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

struct PhotoElementView<ViewModel: ImageSearchViewModel>: View {

    let element: ImageElement
    @ObservedObject var viewModel: ViewModel

    @State private var isElementLoaded = false
    @State private var isFailed = false

    /// 카드 돌리기
    @State private var showBack = false
    /// 회전 각도
    @State private var rotationAngle: Angle = .zero

    @Environment(\.coordinator) var coordinator

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

    private var imageCard: some View {
        VStack {
            thumbnailView
                .onTapGesture {
                    coordinator.push(.detail(url: element.imageUrl))
                }
            setText(text: element.printTitle)
                .allowsHitTesting(false)
            if let printDate = element.printDate {
                setText(text: printDate)
                    .allowsHitTesting(false)
            }
        }

    }

    private var optionCard: some View {

        Button(role: .cancel) {

            viewModel.selectFavorite(element)
        } label: {

            Label("즐겨찾기", systemImage: element.favoriteIcon)
                .symbolRenderingMode(.palette)
        }
        .tint(.blue)
    }

    var body: some View {
        ZStack {
            imageCard
                .rotation3DEffect(.degrees(showBack ? 89.999 : 0), axis: (x: 0, y: 1, z: 0))
                .opacity(showBack ? 0 : 1)
                .animation(.linear(duration: 0.3), value: showBack)

            optionCard
                .rotation3DEffect(.degrees(showBack ? 0 : -89.999), axis: (x: 0, y: 1, z: 0))
                .opacity(showBack ? 1 : 0)
                .animation(.linear(duration: 0.3), value: showBack)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // 탭하면 애니메이션과 함께 showBack 상태를 토글
            withAnimation(.easeInOut(duration: 0.15)) {
                showBack.toggle()
            }
        }
    }
}

//#Preview {
//    PhotoElementView()
//}
