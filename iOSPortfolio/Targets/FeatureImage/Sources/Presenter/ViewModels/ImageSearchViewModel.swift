//
//  ImageSearchViewModel.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import Combine
import Core
import SwiftUI
import Domain

public protocol ImageSearchViewModel: ObservableObject {

    func setSearchText(_ text: String)
    func selectFavorite(_ model: ImageElement)
    func refresh()
    func nextPage(_ model: ImageElement)

    var state: ResultState<ImageSearchEntity> { get set }

}

public class ImageSearchViewModelImpl: ImageSearchViewModel {

    @Published public var state: ResultState<ImageSearchEntity> = .noSearch(NoSearchModel(message: "검색어를 넣어 검색해주세요.") )

    private let searchText = CurrentValueSubject<String, Never>("")
    private var cancellables: Set<AnyCancellable> = []
    private let useCase: ImageSearchUseCase
    private let bookMarkUseCase: BookMarkUseCase
    private var pageNo: Int = 0

    public init(imageSearchUseCase: ImageSearchUseCase, bookMarkUseCase: BookMarkUseCase) {

        useCase = imageSearchUseCase
        self.bookMarkUseCase = bookMarkUseCase
        dataBinding()
    }

    private func dataBinding() {
        searchText.debounce(for: .milliseconds(300), scheduler: DispatchQueue.global(qos: .background))
            .flatMap(fetchResults)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] value in

                
                self?.state = value
            })
            .store(in: &cancellables)

        bookMarkUseCase.bookmarksPublisher
            .sink(receiveValue: {[weak self] bookMarkList in

                guard case .list(var currentResult) = self?.state,
                      let list = self?.bookMarkUseCase.getFavoriteList(targetList: currentResult.elements, bookMarkList: bookMarkList ?? []) else {
                    return
                }

                currentResult.elements = list
                
                self?.state = .list(currentResult)

            }).store(in: &cancellables)
    }

    private func getImageList() async throws -> ImageSearchEntity {
        let searchText = self.searchText.value

        var result = try await self.useCase.searchImage(keyword: searchText, pageNo: self.pageNo + 1, sorting: nil)
        let list = self.bookMarkUseCase.getFavoriteList(targetList: result.elements, bookMarkList: self.bookMarkUseCase.allValues)

        result.elements = list

        return result
    }

    private func fetchResults(_ keyword: String) -> AnyPublisher<ResultState<ImageSearchEntity>, Never> {

        Future<ResultState<ImageSearchEntity>, Never> { promise in

            guard keyword.isEmpty == false else {
                promise(.success(.noSearch(NoSearchModel(message: "검색어를 넣어 검색해주세요.") ) ) )
                return
            }

            Task {[weak self] in

                do {
                    guard let result = try await self?.getImageList() else {
                        return
                    }

                    if result.totalCount == 0 {

                        promise(.success(.empty(ResultEmpty(message: "검색 결과가 없습니다.")) ))
                    } else {
                        promise(.success(.list(result)))
                    }

                    self?.pageNo = 1

                } catch {


                    promise(.success(.error(ResultError(networkError: error) )))
                }
            }
        }.eraseToAnyPublisher()
    }

    public func setSearchText(_ text: String) {

        searchText.send(text)
    }

    public func selectFavorite(_ model: ImageElement) {

        if model.favorite {
            bookMarkUseCase.removeElement(model.convertBookMarkEntity)
        } else {
            bookMarkUseCase.selectElement(model.convertBookMarkEntity)
        }

    }

    public func refresh() {


    }

    private var paginationTask: Task<Void, Never>?

    public func nextPage(_ model: ImageElement) {

        guard case .list(var currentState) = state,
              currentState.elements.last == model,
              paginationTask == nil else {
            return
        }

        paginationTask = Task {[weak self] in

            defer {
                self?.paginationTask = nil
            }

            do {
                guard var result = try await self?.getImageList() else {
                    return
                }

                currentState.elements += result.elements
                result.elements = currentState.elements
                let applyResult = result

                if result.totalCount > 0 {

                    await MainActor.run {[weak self] in
                        self?.state = .list(applyResult)
                    }

                }

            } catch {

                await MainActor.run {[weak self] in
                    self?.state = .error(ResultError(networkError: error) )
                }

            }
        }

    }
}
