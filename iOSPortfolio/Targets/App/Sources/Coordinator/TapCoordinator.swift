//
//  TapCoordinator.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/20/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Combine
import SwiftUI
import UIKit
import FeatureSearch
import FeatureImage
import FeatureBookMark
import Domain
import Data

enum TapType {
    case searchBook
    case image
    case bookMark

    var title: String {
        switch self {
        case .searchBook:
            return "검색"
        case .image:
            return "이미지"
        case .bookMark:
            return "북마크"
        }
    }

    var iconImage: Image {

        switch self {
        case .searchBook:
            return Image(systemName: "magnifyingglass")
        case .image:
            return Image(systemName: "photo.on.rectangle")
        case .bookMark:
            return Image(systemName: "bookmark")
        }
    }
}

@MainActor
class TabCoordinator: ObservableObject {
    // TabView의 selection을 Coordinator가 관리
    @Published var selectedTab: Int = 0

    init() {
        // 앱이 시작될 때 필요한 모든 의존성을 생성 (또는 외부에서 주입받음)
    }

    var bookMarkUseCase: BookMarkUseCase = {

        BookMarkUseCaseImpl(repository: BookMarkRepositoryImpl())
    }()

    // ✅ 1. 홈 뷰 생성 메서드
    @ViewBuilder
    func makeSearchBookView() -> some View {
        // ViewModel을 생성하며 의존성 주입!

        let viewModel = BookSearchViewModelImpl(bookSearchUseCase: BookSearchUseCaseImpl(api: BookSearchAPIImpl()), bookMarkUseCase: bookMarkUseCase)
        BookSearchView<BookSearchViewModelImpl, BookSearchCoordinatorImpl>(title: "", viewModel: viewModel, coordinator: BookSearchCoordinatorImpl() )
    }

    // ✅ 2. 검색 뷰 생성 메서드
    @ViewBuilder
    func makeSearchImageView() -> some View {

        let viewModel = ImageSearchViewModelImpl(imageSearchUseCase: ImageSearchUseCaseImpl(api: ImageSearchAPIImpl()), bookMarkUseCase: bookMarkUseCase )
        ImageSearchView<ImageSearchViewModelImpl, ImageSearchCoordinatorImpl>(title: "", viewModel: viewModel, coordinator: ImageSearchCoordinatorImpl() )
    }

    // ✅ 3. 알림 뷰 생성 메서드
    @ViewBuilder
    func bookMarkView() -> some View {

        BookMarkViewControllerWrapper(viewModel: BookMarkViewModelImpl(useCase: bookMarkUseCase))
    }

    // ✅ TabView 자체를 생성하는 메서드
    @ViewBuilder
    func build(type: TapType) -> some View {
        switch type {
        case .searchBook:
            makeSearchBookView()
                .tabItem {
                    type.iconImage
                    Text(type.title)
                }
                .tag(0)
        case .image:
            makeSearchImageView()
                .tabItem {
                    type.iconImage
                    Text(type.title)
                }
                .tag(1)
        case .bookMark:
            bookMarkView()
                .tabItem {
                    type.iconImage
                    Text(type.title)
                }
                .tag(2)
        }
    }
}
