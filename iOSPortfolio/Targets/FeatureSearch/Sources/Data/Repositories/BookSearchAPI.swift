//
//  BookSearchAPI.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/20/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Data
import Alamofire
import Foundation

/// 책 검색
public protocol BookSearchApiInterface {

    func fetchBook(keyword: String, pageNo: Int, target: SearchTarget, sortingOption: SearchBookSort) async throws -> BookSearchModel
}

public class BookSearchAPIImpl: BookSearchApiInterface, NetworkComm {

    public init() {

    }

    public func fetchBook(keyword: String, pageNo: Int, target: SearchTarget, sortingOption: SearchBookSort) async throws -> BookSearchModel {

        var param = Parameters()

        param["query"] = keyword
        param["page"] = pageNo
        param["target"] = target.rawValue
        param["sort"] = sortingOption.rawValue
        
        let data: BookAPIResponse = try await request(router: .bookSearch, parameters: param)
        
        return data.convertEntity
    }

}
