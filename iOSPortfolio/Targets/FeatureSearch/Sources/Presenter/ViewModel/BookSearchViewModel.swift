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

// 개별 책 정보를 담는 모델
public struct BookData: Codable, Identifiable {
    // Identifiable 프로토콜을 위해 고유 식별자로 isbn을 사용
    public var id: String { isbn }

    let authors: [String]
    let contents: String
    let datetime: String

    /// 화면에 표시할 date
    lazy var printDate: String? = {
        let date = Date(fromString: datetime, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")

        return date?.toString(format: "yyyy-MM-dd")
    }()

    private let isbn: String
    let price: Int
    let publisher: String
    let salePrice: Int
    let status: String
    let thumbnail: String
    let title: String
    let translators: [String]
    let url: String

    lazy var moveUrl: URL? = {

        URL(string: url)
    }()

    public init(authors: [String], contents: String, datetime: String, isbn: String, price: Int, publisher: String, salePrice: Int, status: String, thumbnail: String, title: String, translators: [String], url: String) {

        self.authors = authors
        self.contents = contents
        self.datetime = datetime
        self.isbn = isbn
        self.price = price
        self.publisher = publisher
        self.salePrice = salePrice
        self.status = status
        self.thumbnail = thumbnail
        self.title = title
        self.translators = translators
        self.url = url
    }
}

extension BookData {

    func convertEntity(_ model: BookModel) -> BookData {

        let data = BookData(authors: model.authors, contents: model.contents, datetime: model.datetime, isbn: model.isbn, price: model.price, publisher: model.publisher, salePrice: model.salePrice, status: model.status, thumbnail: model.thumbnail, title: model.title, translators: model.translators, url: model.url)

        return data
    }
}

extension Array where Element == BookModel {

    var convertEntity: [BookData] {

        map({model -> BookData in

            let data = BookData(authors: model.authors, contents: model.contents, datetime: model.datetime, isbn: model.isbn, price: model.price, publisher: model.publisher, salePrice: model.salePrice, status: model.status, thumbnail: model.thumbnail, title: model.title, translators: model.translators, url: model.url)

            return data
        })

    }
}

public enum SearchBookState {

    case noSearch
    case empty
    case list([BookData])
    case error(NSError)
}

@MainActor
public protocol BookSearchViewModel: ObservableObject {

    func setSearchText(_ text: String)
    func scrollView()

    var state: SearchBookState { get set }
}


@MainActor
final public class BookSearchViewModelImpl: BookSearchViewModel {

    @Published public var state: SearchBookState = .noSearch

    let bookSearchUseCase: BookSearchUseCase

    private let searchText = CurrentValueSubject<String, Never>("")
    private var cancellables: Set<AnyCancellable> = []

    public init(bookSearchUseCase: BookSearchUseCase) {

        self.bookSearchUseCase = bookSearchUseCase
        dataBinding()
    }

    func dataBinding() {

        searchText.debounce(for: .milliseconds(300), scheduler: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .flatMap(fetchResults)
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }

    private func fetchResults(_ keyword: String) -> Future<SearchBookState, Never> {

        return Future { promise in

            guard keyword.isEmpty == false else {
                promise(.success(.noSearch) )
                return
            }

            Task {[weak self] in
                
                do {
                    let list = try await self?.bookSearchUseCase.searchBook(keyword: keyword)

                    if (list?.convertEntity.count ?? 0) == 0 {
                        promise(.success(.empty))
                    } else {
                        promise(.success(.list(list?.convertEntity ?? [] )))
                    }

                } catch {

                    promise(.success(.error(error as NSError)))
                }
            }
        }
    }
    
    public func setSearchText(_ text: String) {

        searchText.send(text)
    }

    public func scrollView() {
        
    }
}
