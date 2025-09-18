//
//  ImageListView.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import SwiftUI

public struct ImageListView<ViewModel: ImageSearchViewModel>: View {

    @ObservedObject var viewModel: ViewModel
    @Environment(\.coordinator) var coordinator

    public init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
    }

    // 3열 그리드
    private var columns: [GridItem] = {
        (0 ..< 3).map { _ -> GridItem in
            GridItem(.flexible())
        }
    }()

    private var documents: [ImageElement] {
        if case .list(let data) = viewModel.state {
            return data.elements
        }
        return []
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(documents, id: \.id) { item in
                    PhotoElementView(element: item, viewModel: viewModel)
                        .onAppear {
                            viewModel.nextPage(item)
                        }
                }
            }
        }
        .refreshable {
            viewModel.refresh()
        }
        .scrollDismissesKeyboard(.automatic)
    }
}
