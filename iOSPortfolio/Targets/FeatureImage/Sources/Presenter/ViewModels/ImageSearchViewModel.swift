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

public protocol ImageSearchViewModel: ObservableObject {

    func setSearchText(_ text: String)
    func refresh()
    func nextPage(_ model: ImageElement)

    var state: ResultState<ImageSearchEntity> { get set }

}

public class ImageSearchViewModelImpl: ImageSearchViewModel {

    @Published public var state: ResultState<ImageSearchEntity> = .noSearch(Image(systemName: "rectangle.and.text.magnifyingglass"), "검색어를 넣어 검색해주세요.")

    private let searchText = CurrentValueSubject<String, Never>("")
    private var cancellables: Set<AnyCancellable> = []
    private let useCase: ImageSearchUseCase
    private var pageNo: Int = 1

    public init(imageSearchUseCase: ImageSearchUseCase) {

        useCase = imageSearchUseCase
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
    }

    private func fetchResults(_ keyword: String) -> AnyPublisher<ResultState<ImageSearchEntity>, Never> {

        Future<ResultState<ImageSearchEntity>, Never> { promise in

            guard keyword.isEmpty == false else {
                promise(.success(.noSearch(Image(systemName: "rectangle.and.text.magnifyingglass"), "검색어를 넣어 검색해주세요.") ) )
                return
            }

            Task {[weak self] in

                do {
                    guard let result = try await self?.useCase.searchImage(keyword: keyword, pageNo: 1, sorting: nil) else {
                        return
                    }

                    if result.totalCount == 0 {
                        promise(.success(.empty(Image(systemName: "exclamationmark.icloud"), "검색 결과가 없습니다.") ))
                    } else {
                        promise(.success(.list(result)))
                    }

                } catch {

                    promise(.success(.error(error as NSError)))
                }
            }
        }.eraseToAnyPublisher()
    }

    public func setSearchText(_ text: String) {

        searchText.send(text)
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
                guard let keyword = self?.searchText.value,
                      var result = try await self?.useCase.searchImage(keyword: keyword, pageNo: (self?.pageNo ?? 1) + 1, sorting: nil) else {
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
                    self?.state = .error(error as NSError)
                }

            }
        }

    }
}
