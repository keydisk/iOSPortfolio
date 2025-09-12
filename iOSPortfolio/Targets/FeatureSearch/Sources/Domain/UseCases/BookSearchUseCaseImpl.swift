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
    func searchBook(keyword: String) async throws -> [BookModel]

    /// 옵션 설정
    /// - Parameters:
    ///   - target: 타겟 설정
    ///   - sortingOption: 정렬 타입
    func setSearchOption(target: SearchTarget, sortingOption: SearchBookSort)

    /// 다음 뷰
    func nextPage() async throws -> [BookModel]
}


/// 책 검색 유즈케이스
public class BookSearchUseCaseImpl: BookSearchUseCase {

    let api: BookSearchApiInterface
    private var pageNo: Int = 1
    private var target: SearchTarget = .title
    private var sorting: SearchBookSort = .accuracy
    private var keyword = ""
    private var state: BookSearchModel?

    public init(api: BookSearchApiInterface) {

        self.api = api
    }

    public func searchBook(keyword: String) async throws -> [BookModel] {

        guard keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            throw NSError(domain: "키워드가 비어 있음", code: 700)
        }

        self.keyword = keyword
        self.pageNo = 1

        state = try await api.fetchBook(keyword: keyword, pageNo: pageNo, target: target, sortingOption: sorting)
        return state?.documents ?? []
    }

    public func setSearchOption(target: SearchTarget, sortingOption: SearchBookSort) {

        self.target  = target
        self.sorting = sortingOption
    }

    public func nextPage() async throws -> [BookModel] {

        guard keyword.isEmpty == false else {
            throw NSError(domain: "키워드가 비어 있음", code: 700)
        }

        pageNo += 1
        let rtnValue = try await api.fetchBook(keyword: keyword, pageNo: pageNo, target: target, sortingOption: sorting)

        rtnValue.documents.forEach { value in
            state?.documents.append(value)
        }

        return state?.documents ?? []
    }
}
