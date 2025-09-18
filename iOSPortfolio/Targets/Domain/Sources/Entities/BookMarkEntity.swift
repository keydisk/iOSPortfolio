//
//  BookMarkEntity.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/16/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Foundation
import SwiftUI

public protocol WithBookMarkList: Identifiable {

    var id: String {get set}
    var favorite: Bool {get set}
}

public enum BookMarkElementType: Int {

    case bookSearch, imageSearch
}

public struct BookMarkEntity: Identifiable {

    public var id: String
    public var title: String
    public var thumbnailImgUrl: String
    public var moveUrl: String
    public var registDate: Date
    public var type: BookMarkElementType

    public init(id: String, title: String, thumbnailImgUrl: String, moveUrl: String, registDate: Date, type: BookMarkElementType) {

        self.id = id
        self.title = title
        self.thumbnailImgUrl = thumbnailImgUrl
        self.moveUrl = moveUrl
        self.registDate = registDate
        self.type = type
    }
}
