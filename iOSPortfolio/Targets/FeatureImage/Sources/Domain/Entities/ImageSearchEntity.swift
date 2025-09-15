//
//  ImageSearchEntity.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

public struct ImageSearchEntity: Codable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool

    var elements: [ImageElement]
}

// MARK: - ImageDocument (개별 이미지 문서)
public struct ImageElement: Codable, Identifiable, Hashable {

    // 여기서는 docUrl을 id로 가정합니다.
    public var id: String { imageUrl }

    let collection: String
    let thumbnailUrl: String
    let imageUrl: String
    let width: Int
    let height: Int
    let displaySitename: String
    let docUrl: String
    let datetime: String // Date 타입으로 파싱할 수도 있습니다.
}
