//
//  BookSearchCoordinator.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/12/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Combine
import SwiftUI
import Core

public enum BookSearchNavigationType: Hashable {
    /// 앱 검색
    case detail(url: String)

}

// 2. Key 생성
private struct BookSearchCoordinatorKey: EnvironmentKey {
    static var defaultValue: any BookSearchCoordinator = BookSearchCoordinatorImpl()
}

// 3. EnvironmentValues 확장
extension EnvironmentValues {
    var coordinator: any BookSearchCoordinator {
        get { self[BookSearchCoordinatorKey.self] }
        set { self[BookSearchCoordinatorKey.self] = newValue }
    }
}

public protocol BookSearchCoordinator: CommonCoordinator where NaviElement == BookSearchNavigationType {

}

public class BookSearchCoordinatorImpl: BookSearchCoordinator {

    public typealias NaviElement = BookSearchNavigationType

    /// 네비게이션 상태
    @Published public var naviPath: [NaviElement] = []

    public init() {

    }

    @ViewBuilder
    public func makeView(type: NaviElement) -> some View {
        // ViewModel을 생성하며 의존성 주입!

        switch type {
        case .detail(url: let url):
            let useCase = BookDetailUseCaseImpl()
            BookDetailView<BookDetailViewModelImpl>(viewModel: BookDetailViewModelImpl(useCase: useCase, state: url))
        }
    }
}
