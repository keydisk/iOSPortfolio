//
//  ViewModels.swift
//  FeaturePhotoViewer
//
//  Tuist 인식을 위한 더미 파일입니다.
//
import Foundation
import Combine
import Core
import SwiftUI

public protocol PhotoViewModel: ObservableObject {

    var state: ResultState<[PhotoEntity]> { get set }
    func loadPhotos()
    func nextPage(_ item: PhotoEntity)
    func refresh()
}

public class PhotoViewModelImpl: PhotoViewModel {

    @Published public var state: ResultState<[PhotoEntity]> = .empty(ResultEmpty(message: "이미지가 없습니다."))

    private var pageNo: Int = 1

    let photoUseCase: PhotoUseCase

    public init(photoUseCase: PhotoUseCase) {

        self.photoUseCase = photoUseCase
    }

    public func loadPhotos() {

        Task {[weak self] in
            do {
                guard let pageNo = self?.pageNo,
                      let list = try await self?.photoUseCase.loadingPhotoAsset(pageNo: pageNo) else {

                    return
                }

                await MainActor.run {[weak self] in
                    if list.isEmpty {
                        self?.state = .empty(ResultEmpty(message: "이미지가 없습니다."))
                    } else {
                        self?.state = .list(list)
                    }
                }

            } catch {
                
            }
        }
    }

    public func nextPage(_ item: PhotoEntity) {

    }

    public func refresh() {

    }
}
