//
//  BookMarkData.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/16/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import Foundation
import RealmSwift
import Domain

public class BookMarkData: Object {

    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String = ""
    @Persisted var thumbnailUrl: String = ""
    @Persisted var moveUrl: String = ""
    @Persisted var createdDate: Date = Date()
    @Persisted var type: Int = BookMarkElementType.bookSearch.rawValue

    @objc required override init() {
        super.init()
    }
    
    public init(id: String, title: String, thumbnailUrl: String, moveUrl: String, type: Int) {

        super.init()

        self.id = id
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.moveUrl = moveUrl
        self.type = type
    }
}

extension BookMarkData {

    var convertEntity: BookMarkEntity {

        BookMarkEntity(id: id, title: title, thumbnailImgUrl: thumbnailUrl, moveUrl: moveUrl, registDate: createdDate, type: BookMarkElementType(rawValue: type)! )
    }
}
