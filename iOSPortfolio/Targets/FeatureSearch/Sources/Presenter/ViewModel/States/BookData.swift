//
//  BookData.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Core
import Foundation

public struct BookSearchModel: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int

    var documents: [BookData]
}


// 개별 책 정보를 담는 모델
public struct BookData: Codable, Identifiable, Equatable {
    // Identifiable 프로토콜을 위해 고유 식별자로 isbn을 사용
    public var id: String { url }

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


extension Array where Element == BookModel {

    var convertEntity: [BookData] {

        map({model -> BookData in

            let data = BookData(authors: model.authors, contents: model.contents, datetime: model.datetime, isbn: model.isbn, price: model.price, publisher: model.publisher, salePrice: model.salePrice, status: model.status, thumbnail: model.thumbnail, title: model.title, translators: model.translators, url: model.url)

            return data
        })

    }
}

extension BookSearchEntity {

    var convertViewState: BookSearchModel {
        BookSearchModel(isEnd: isEnd, pageableCount: pageableCount, totalCount: totalCount, documents: documents.map({model -> BookData in

            let data = BookData(authors: model.authors, contents: model.contents, datetime: model.datetime, isbn: model.isbn, price: model.price, publisher: model.publisher, salePrice: model.salePrice, status: model.status, thumbnail: model.thumbnail, title: model.title, translators: model.translators, url: model.url)

            return data
        }))
    }
}
