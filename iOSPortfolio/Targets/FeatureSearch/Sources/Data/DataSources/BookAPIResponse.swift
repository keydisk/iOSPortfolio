//
//  BookAPIResponse.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/19/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import Foundation

// API 응답 전체 구조를 나타내는 최상위 모델
struct BookAPIResponse: Codable {
    let meta: MetaInfo
    let documents: [BookDocument]
}

// meta 정보를 담는 모델
struct MetaInfo: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int

    // JSON의 snake_case 키를 Swift의 camelCase 프로퍼티로 매핑
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}

// 개별 책 정보를 담는 모델
struct BookDocument: Codable, Identifiable {
    // Identifiable 프로토콜을 위해 고유 식별자로 isbn을 사용
    var id: String { isbn }

    let authors: [String]
    let contents: String
    let datetime: String
    let isbn: String
    let price: Int
    let publisher: String
    let salePrice: Int
    let status: String
    let thumbnail: String
    let title: String
    let translators: [String]
    let url: String

    enum CodingKeys: String, CodingKey {
        case authors, contents, datetime, isbn, price, publisher, status, thumbnail, title, translators, url
        case salePrice = "sale_price"
    }
}

extension BookAPIResponse {
    var convertEntity: BookSearchModel {
        BookSearchModel(isEnd: meta.isEnd, pageableCount: meta.pageableCount, totalCount: meta.totalCount, documents: documents.map({value -> BookModel in
            BookModel(authors: value.authors, contents: value.contents, datetime: value.datetime, isbn: value.isbn, price: value.price, publisher: value.publisher, salePrice: value.salePrice, status: value.status, thumbnail: value.thumbnail, title: value.title, translators: value.translators, url: value.url)
        }))
    }
}


