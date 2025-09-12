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

    func testView() -> some View {

        return Text("")
    }

    public var body: some View {

        NavigationStack(path: $coordinator.naviPath) {
            VStack {
                CustomTextField(searchText: $searchText, option: .search, placeholder: "Search")
                    .onChange(of: searchText) { text in

                        viewModel.setSearchText(text)
                    }
                    .padding(.horizontal, 8)

                switch viewModel.state {
                case .empty:

                    Text("Empty View")
                case .error(let error):

                    Text("Error: \(error.description)")
                case .list(let list):

                    BookListView<ViewModel>(viewModel: viewModel, documents: list)
                        .environmentObject(coordinator)


                case .noSearch:

                    Text("no searchView")
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
