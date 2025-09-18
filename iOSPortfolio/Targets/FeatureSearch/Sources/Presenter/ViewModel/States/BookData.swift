//
//  BookData.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Core
import Foundation
import Combine
import Domain

public struct BookSearchModel: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int

    var documents: [BookData]
}

// 개별 책 정보를 담는 모델
public struct BookData: Codable, WithBookMarkList, Equatable {
    // Identifiable 프로토콜을 위해 고유 식별자로 isbn을 사용
    public var id: String

    let authors: [String]
    let contents: String
    let datetime: String

    /// 화면에 표시할 date
    lazy var printDate: String? = {
        Date(fromString: datetime, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")?.toString(format: "yyyy-MM-dd")
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
    public var favorite: Bool = false

    lazy var moveUrl: URL? = {

        URL(string: url)
    }()

    public init(id: String, authors: [String], contents: String, datetime: String, isbn: String, price: Int, publisher: String, salePrice: Int, status: String, thumbnail: String, title: String, translators: [String], url: String) {

        self.id = id
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

            let data = BookData(id: UUID().uuidString, authors: model.authors, contents: model.contents, datetime: model.datetime, isbn: model.isbn, price: model.price, publisher: model.publisher, salePrice: model.salePrice, status: model.status, thumbnail: model.thumbnail, title: model.title, translators: model.translators, url: model.url)

            return data
        })

    }
}

extension BookSearchEntity {

    var convertViewState: BookSearchModel {
        BookSearchModel(isEnd: isEnd, pageableCount: pageableCount, totalCount: totalCount, documents: documents.map({model -> BookData in

            let data = BookData(id: UUID().uuidString, authors: model.authors, contents: model.contents, datetime: model.datetime, isbn: model.isbn, price: model.price, publisher: model.publisher, salePrice: model.salePrice, status: model.status, thumbnail: model.thumbnail, title: model.title, translators: model.translators, url: model.url)

            return data
        }))
    }
}

extension BookData {

    var favoriteIcon: String {
        favorite ? "star.fill" : "star.leadinghalf.filled"
    }

    var convertBookMarkEntity: BookMarkEntity {

        BookMarkEntity(id: id, title: title, thumbnailImgUrl: thumbnail, moveUrl: url, registDate: Date(), type: .bookSearch)
    }
}
