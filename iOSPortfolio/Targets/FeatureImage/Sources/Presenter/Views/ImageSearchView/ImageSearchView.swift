//
//  ImageSearchView.swift
//  FeatureImage
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import SwiftUI
import DesignSystem

public struct ImageSearchView<ViewModel: ImageSearchViewModel, Coordinator: ImageSearchCoordinator>: View {

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
                    .accessibilityIdentifier("imageSearchTextField")

                switch viewModel.state {
                case .empty(let emptyModel):

                    StatePrintView(stateModel: emptyModel)
                case .error(let error):

                    StatePrintView(stateModel: error)
                case .list:

                    ImageListView(viewModel: viewModel)
                        .environmentObject(coordinator)
                        .padding(.horizontal, 8)
                        .accessibilityIdentifier("imageList")
                case .noSearch(let model):

                    StatePrintView(stateModel: model)
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
