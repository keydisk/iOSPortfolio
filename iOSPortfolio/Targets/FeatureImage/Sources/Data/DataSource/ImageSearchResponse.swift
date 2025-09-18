//
//  ImageSearchResponse.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import Foundation

// MARK: - ImageSearchResponse (JSON 전체 구조)
// API 응답의 최상위 레벨에 해당합니다.
struct ImageSearchResponse: Codable {
    let meta: MetaInfo
    let documents: [ImageDocument]
}

// MARK: - MetaInfo (meta 정보)
// 페이징 및 검색 결과 수와 관련된 정보를 담습니다.
struct MetaInfo: Codable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool

    // JSON 키(snake_case)와 Swift 프로퍼티(camelCase)를 매핑합니다.
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

// MARK: - ImageDocument (개별 이미지 문서)
struct ImageDocument: Codable, Identifiable, Hashable {

    // 여기서는 docUrl을 id로 가정합니다.
    var id: String { docUrl }

    let collection: String
    let thumbnailUrl: String
    let imageUrl: String
    let width: Int
    let height: Int
    let displaySitename: String
    let docUrl: String
    let datetime: String // Date 타입으로 파싱할 수도 있습니다.

    enum CodingKeys: String, CodingKey {
        case collection
        case thumbnailUrl = "thumbnail_url"
        case imageUrl = "image_url"
        case width, height
        case displaySitename = "display_sitename"
        case docUrl = "doc_url"
        case datetime
    }
}

extension ImageSearchResponse {
    
    var convertEntity: ImageSearchEntity {

        ImageSearchEntity(totalCount: meta.totalCount, pageableCount: meta.pageableCount, isEnd: meta.isEnd, elements: documents.map({model -> ImageElement in

            ImageElement(id: UUID().uuidString, collection: model.collection, thumbnailUrl: model.thumbnailUrl, imageUrl: model.imageUrl, width: model.width, height: model.height, displaySitename: model.displaySitename, docUrl: model.docUrl, datetime: model.datetime)
        }))
    }
}
