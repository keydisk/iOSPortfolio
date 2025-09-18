//
//  ImageSearchUseCase.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import Foundation

public protocol ImageSearchUseCase {

    func searchImage(keyword: String, pageNo: Int, sorting: (any ImageSearchOptionProtocol)?) async throws -> ImageSearchEntity
}

/// 이미지 검색
public protocol ImageSearchApiInterface {

    func fetchImage(keyword: String, pageNo: Int, sort: (any ImageSearchOptionProtocol)?) async throws -> ImageSearchEntity
}


public class ImageSearchUseCaseImpl: ImageSearchUseCase {

    let api: ImageSearchApiInterface

    public init(api: ImageSearchApiInterface) {
        self.api = api
    }

    public func searchImage(keyword: String, pageNo: Int, sorting: (any ImageSearchOptionProtocol)? = nil) async throws -> ImageSearchEntity {

        guard keyword.isEmpty == false else {
            throw NSError(domain: "empty keyword", code: 999)
        }

        return try await api.fetchImage(keyword: keyword, pageNo: pageNo, sort: sorting)
    }
}
