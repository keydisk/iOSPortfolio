//
//  BookMarkState.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/16/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import RxCocoa
import RxSwift
import RxDataSources
import Foundation
import Domain

extension BookMarkEntity: @retroactive IdentifiableType, @retroactive Equatable {
    public var identity: String {
        id
    }

    public static func == (lhs: BookMarkEntity, rhs: BookMarkEntity) -> Bool {
        return lhs.id == rhs.id
    }

    var thumbmailUrl: URL? {
        URL(string: thumbnailImgUrl)
    }

    var detailUrl: URL? {
        URL(string: moveUrl)
    }

    var printDate: String {
        
        registDate.toString(format: "yyyy-MM-dd")
    }
}

extension Array where Element == BookMarkEntity {
    var convertItemSection: BookMarkItemSection {

        BookMarkItemSection(model: first?.id ?? "", items: self)
    }
}

public typealias BookMarkItemSection = AnimatableSectionModel<String, BookMarkEntity>
