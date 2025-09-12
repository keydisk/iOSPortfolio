//
//  SearchTarget.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/19/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

// In Domain Layer
public protocol SearchOptionProtocol: RawRepresentable, CaseIterable where RawValue == String {

    var displayName: String {get}
    var paramValue: String {get}
}

extension SearchOptionProtocol {

    public var paramValue: String {
        rawValue
    }
}

// CaseIterable: 모든 케이스를 배열(.allCases)로 가져올 수 있게 함
// Identifiable: ForEach에서 각 항목을 고유하게 식별할 수 있게 함
public enum SearchTarget: String, SearchOptionProtocol, Identifiable {
    case title
    case isbn
    case publisher
    case person

    // ForEach를 위한 id 프로퍼티
    public var id: Self { self }

    // UI에 표시될 이름
    public var displayName: String {
        switch self {
        case .title:
            return "제목"
        case .isbn:
            return "ISBN"
        case .publisher:
            return "출판사"
        case .person:
            return "인명"
        }
    }
}

public enum SearchBookSort: String, SearchOptionProtocol, Identifiable {
    case accuracy
    case latest

    public var id: Self { self }
    
    public var displayName: String {
        if self == .accuracy {
            return "정확도순"
        } else {
            return "발간일순"
        }
    }
}
