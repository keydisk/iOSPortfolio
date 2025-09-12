//
//  BookAPIResponse.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/19/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import Foundation
import Core

// API 응답 전체 구조를 나타내는 최상위 모델
public struct BookSearchModel: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int

    var documents: [BookModel]
}

// 개별 책 정보를 담는 모델
public struct BookModel: Codable, Identifiable {
    // Identifiable 프로토콜을 위해 고유 식별자로 isbn을 사용
    public var id: String { isbn }

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
}
