//
//  BookSearchView.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/14/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Foundation
import Combine
import SwiftUI
import DesignSystem
import Core

/// 책 검색 뷰
public struct BookSearchView<ViewModel: BookSearchViewModel, Coordinator: BookSearchCoordinator>: View {

    @State private var title = ""
    @State private var searchText = ""
    @ObservedObject private var viewModel: ViewModel
    @ObservedObject private var coordinator: Coordinator

    public init(title: String, viewModel: ViewModel, coordinator: Coordinator) {

        self.title = title
        self.viewModel = viewModel
        self.coordinator = coordinator
    }

    public var body: some View {

        NavigationStack(path: $coordinator.naviPath) {
            VStack {
                CustomTextField(searchText: $searchText, option: .search, placeholder: "Search")
                    .onChange(of: searchText) { text in

                        viewModel.setSearchText(text)
                    }
                    .padding(.horizontal, 8)
                    .accessibilityIdentifier("bookSearchTextField")

                switch viewModel.state {
                case .empty(let emptyModel):

                    StatePrintView(stateModel: emptyModel)
                case .error(let errorModel):

                    StatePrintView(stateModel: errorModel)

                case .list:

                    BookListView<ViewModel>(viewModel: viewModel)
                        .environmentObject(coordinator)
                        .padding(.horizontal, 8)
                        .accessibilityIdentifier("bookListView")
                case .noSearch(let noSearchModel):

                    StatePrintView(stateModel: noSearchModel)
                }

                Spacer()
            }
            .navigationDestination(for: Coordinator.NaviElement.self, destination: { type in

                coordinator.makeView(type: type)
            })
        }
        .environment(\.coordinator, coordinator)
    }
}
