//
//  BookDetailView.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/14/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import SwiftUI
import Core
import DesignSystem

/// 상세보기 적용
struct BookDetailView<ViewModel: BookDetailViewModel>: View {

    @ObservedObject var viewModel: ViewModel
    @Environment(\.coordinator) var coordinator

    public init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        SUWebView(url: viewModel.state)
            .navigationBarBackButtonHidden(true) // 시스템 기본 백버튼 숨김
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.backward")
                            .imageScale(.medium)
                        Text("뒤로가기")
                            .modifier(TextDecoration(textType: .contents))
                    }
                    .accessibilityIdentifier("webViewBack")
                    .onTapGesture {

                        coordinator.pop()
                    }
                }
            }

    }
}
