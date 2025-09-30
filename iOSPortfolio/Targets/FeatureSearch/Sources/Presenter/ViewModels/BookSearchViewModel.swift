//
//  SearchIntent.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/19/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Foundation
import Combine
import Core
import SwiftUI
import Domain

public protocol BookSearchViewModel: ObservableObject {

    func setSearchText(_ text: String)
    func setFavorite(_ model: BookData)
    func refresh()
    func nextPage(_ model: BookData)

    var state: ResultState<BookSearchModel> { get set }
}

final public class BookSearchViewModelImpl: BookSearchViewModel {

    @Published public var state: ResultState<BookSearchModel> =
        .noSearch(NoSearchModel(message: "검색어를 넣어 검색해주세요.") )


    let bookSearchUseCase: BookSearchUseCase
    let bookMarkUseCase: BookMarkUseCase

    private let searchText = CurrentValueSubject<String, Never>("")
    private var cancellables: Set<AnyCancellable> = []
    private var pageNo: Int = 0

    public init(bookSearchUseCase: BookSearchUseCase, bookMarkUseCase: BookMarkUseCase) {

        self.bookSearchUseCase = bookSearchUseCase
        self.bookMarkUseCase   = bookMarkUseCase

        dataBinding()
    }

    func dataBinding() {

        searchText.debounce(for: .milliseconds(300), scheduler: DispatchQueue.global(qos: .background))
            .flatMap(fetchResults)
            .receive(on: DispatchQueue.main)
            .assign(to: \.state, on: self)
            .store(in: &cancellables)

        bookMarkUseCase.bookmarksPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in

                guard case .list(var currentValue) = self?.state,
                      let result = self?.bookMarkUseCase.getFavoriteList(targetList: currentValue.documents, bookMarkList: list ?? []) else {
                    return
                }

                currentValue.documents = result
                self?.state = .list(currentValue)
            }
            .store(in: &cancellables)
    }

    private func getBookList() async throws -> BookSearchModel {
        let searchText = self.searchText.value

        var result = try await self.bookSearchUseCase.searchBook(keyword: searchText, pageNo: self.pageNo + 1, target: nil, sorting: nil).convertViewState
        let list = self.bookMarkUseCase.getFavoriteList(targetList: result.documents, bookMarkList: self.bookMarkUseCase.allValues)
        result.documents = list

        return result
    }

    private func fetchResults(_ keyword: String) -> Future<ResultState<BookSearchModel>, Never> {

        return Future { promise in

            guard keyword.isEmpty == false else {
                promise(.success(.noSearch(NoSearchModel(message: "검색어를 넣어 검색해주세요.")) ) )
                return
            }

            Task {[weak self] in

                do {
                    guard let result = try await self?.getBookList() else {

                        return
                    }

                    if result.totalCount == 0 {
                        promise(.success(.empty(ResultEmpty(message: "검색 결과가 없습니다.") )) )

                    } else {
                        promise(.success(.list(result)))
                    }

                    self?.pageNo = 1

                } catch {

                    promise(.success(.error(ResultError(networkError: error) ) ) )
                }
            }
        }
    }

    public func setSearchText(_ text: String) {

        searchText.send(text)
    }

    public func refresh() {

        Task {
            let result = await fetchResults(searchText.value).value
            await MainActor.run {
                state = result
            }
        }
    }

    public func setFavorite(_ model: BookData) {

        if model.favorite {

            bookMarkUseCase.removeElement(model.convertBookMarkEntity)
        } else {
            
            bookMarkUseCase.selectElement(model.convertBookMarkEntity)
        }
    }

    private var confirmModel: BookData?
    public func nextPage(_ model: BookData) {

        guard case .list(let value) = state,
              model.id == value.documents.last?.id,
              value.isEnd == false,
              confirmModel != model else {

            return
        }

        confirmModel = model

        Task {[weak self] in

            do {
                guard var result = try await self?.getBookList() else {

                    return
                }

                result.documents = value.documents + result.documents
                let applyResult = result

                if result.totalCount > 0 {

                    await MainActor.run {[weak self] in
                        self?.state = .list(applyResult)
                        self?.pageNo += 1
                    }
                }

            } catch {

                await MainActor.run {[weak self] in
                    
                    self?.state = .error(ResultError(networkError: error))
                }

            }
        }
    }

}
