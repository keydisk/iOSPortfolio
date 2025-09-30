//
//  PhotoListView.swift
//  FeaturePhotoViewer
//
//  Tuist 인식을 위한 더미 파일입니다.
//
import SwiftUI
import DesignSystem

public struct PhotoBookListView<ViewModel: PhotoViewModel, Coordinator: PhotoViewCoordinator>: View {

    @ObservedObject private var viewModel: ViewModel
    @ObservedObject private var coordinator: Coordinator

    public init(viewModel: ViewModel, coordinator: Coordinator) {

        self.viewModel = viewModel
        self.coordinator = coordinator
    }

    public var body: some View {
        VStack {

            switch viewModel.state {
            case .empty(let emptyModel):

                StatePrintView(stateModel: emptyModel)
            case .error(let errorModel):

                StatePrintView(stateModel: errorModel)

            case .list:

                PhotoListView(viewModel: viewModel)
                    .environmentObject(coordinator)
                    .padding(.horizontal, 8)
                    .accessibilityIdentifier("photoBookListView")

            case .noSearch(let noSearchModel):

                StatePrintView(stateModel: noSearchModel)
            }

        }
        .onAppear {
            viewModel.loadPhotos()
        }
    }
}
