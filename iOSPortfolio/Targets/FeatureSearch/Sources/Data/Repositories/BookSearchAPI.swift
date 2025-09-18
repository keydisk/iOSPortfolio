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

public class BookSearchAPIImpl: BookSearchApiInterface, NetworkComm {

    public init() {

    }

    public func fetchBook(keyword: String, pageNo: Int, target: (any BookSearchOptionProtocol)?, sortingOption: (any BookSearchOptionProtocol)?) async throws -> BookSearchEntity {

        var param = Parameters()

        param["query"] = keyword
        param["page"] = pageNo
        if let targetValue = target?.paramValue {
            param["target"] = targetValue
        }
        
        if let sort = sortingOption?.paramValue {
            param["sort"] = sort
        }
        
        let data: BookAPIResponse = try await request(router: .bookSearch, parameters: param)
        
        return data.convertEntity
    }

}
