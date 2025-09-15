//
//  TapCoordinator.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/20/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Combine
import SwiftUI
import FeatureSearch
import FeatureImage

enum TapType {
    case searchBook
    case image
    case bookMark
    case setting
}

@MainActor
class TabCoordinator: ObservableObject {
    // TabView의 selection을 Coordinator가 관리
    @Published var selectedTab: Int = 0

    // ✅ 의존성을 Coordinator가 소유

    init() {
        // 앱이 시작될 때 필요한 모든 의존성을 생성 (또는 외부에서 주입받음)
    }

    // --- View Factory Methods ---

    // ✅ 1. 홈 뷰 생성 메서드
    @ViewBuilder
    func makeSearchBookView() -> some View {
        // ViewModel을 생성하며 의존성 주입!

        let viewModel = BookSearchViewModelImpl(bookSearchUseCase: BookSearchUseCaseImpl(api: BookSearchAPIImpl()))
        BookSearchView<BookSearchViewModelImpl, BookSearchCoordinatorImpl>(title: "", viewModel: viewModel, coordinator: BookSearchCoordinatorImpl() )
    }

    // ✅ 2. 검색 뷰 생성 메서드
    @ViewBuilder
    func makeSearchImageView() -> some View {

        let viewModel = ImageSearchViewModelImpl(imageSearchUseCase: ImageSearchUseCaseImpl(api: ImageSearchAPIImpl()) )
        ImageSearchView<ImageSearchViewModelImpl, ImageSearchCoordinatorImpl>(title: "", viewModel: viewModel, coordinator: ImageSearchCoordinatorImpl() )
    }

    // ✅ 3. 알림 뷰 생성 메서드
    @ViewBuilder
    func makeNotificationsView() -> some View {

        let viewModel = BookSearchViewModelImpl(bookSearchUseCase: BookSearchUseCaseImpl(api: BookSearchAPIImpl()))
        BookSearchView<BookSearchViewModelImpl, BookSearchCoordinatorImpl>(title: "", viewModel: viewModel, coordinator: BookSearchCoordinatorImpl() )
    }

    // ✅ TabView 자체를 생성하는 메서드
    @ViewBuilder
    func build(type: TapType) -> some View {
        switch type {
        case .searchBook:
            makeSearchBookView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("검색")
                }
                .tag(0)
        case .image:
            makeSearchImageView()
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("이미지")
                }
                .tag(1)
        case .bookMark:
            makeSearchBookView()
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("북마크")
                }
                .tag(2)
        case .setting:
            makeSearchBookView()
                .tabItem {
                    Image(systemName: "widget.small")
                    Text("설정")
                }
                .tag(3)

        }
    }
}
