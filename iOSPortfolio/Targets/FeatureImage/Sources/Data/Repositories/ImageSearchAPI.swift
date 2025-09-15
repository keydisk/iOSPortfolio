//
//  ImageSearchAPI.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Core
import Data
import Alamofire

/// 이미지 검색
public protocol ImageSearchApiInterface {

    func fetchImage(keyword: String, pageNo: Int, sort: (any ImageSearchOptionProtocol)?) async throws -> ImageSearchEntity
}

public class ImageSearchAPIImpl: ImageSearchApiInterface, NetworkComm {

    public init() {

    }

    public func fetchImage(keyword: String, pageNo: Int, sort: (any ImageSearchOptionProtocol)?) async throws -> ImageSearchEntity {

        var param = Parameters()

        param["query"] = keyword
        param["page"] = pageNo

        if let sort = sort?.rawValue {
            param["sort"] = sort
        }

        let data: ImageSearchResponse = try await request(router: .imageSearch, parameters: param)

        return data.convertEntity
    }

}
