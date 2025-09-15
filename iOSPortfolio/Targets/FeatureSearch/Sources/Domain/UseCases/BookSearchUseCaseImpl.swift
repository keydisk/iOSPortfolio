//
//  BookSearchUseCaseImpl.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/19/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Combine
import Foundation

/// 책 검색
public protocol BookSearchUseCase {

    /// 검색하기
    /// - Parameters:
    ///   - keyword: 검색 키워드
    ///   - pageNo: 페이지 넘버
    /// - Returns: 검색 결과
    func searchBook(keyword: String, pageNo: Int, target: BookSearchTarget?, sorting: BookSearchBookSort?) async throws -> BookSearchEntity

}


/// 책 검색 유즈케이스
public class BookSearchUseCaseImpl: BookSearchUseCase {

    let api: BookSearchApiInterface

    private var keyword = ""

    public init(api: BookSearchApiInterface) {

        self.api = api
    }

    public func searchBook(keyword: String, pageNo: Int, target: BookSearchTarget?, sorting: BookSearchBookSort?) async throws -> BookSearchEntity {

        guard keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            
            throw NSError(domain: "키워드가 비어 있음", code: 700)
        }

        return try await api.fetchBook(keyword: keyword, pageNo: pageNo, target: target, sortingOption: sorting)
    }

}
