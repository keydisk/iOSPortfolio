//
//  ImageData.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Foundation
import Core
import Domain

extension ImageElement {

    var thumbnailURL: URL? {

        URL(string: thumbnailUrl)
    }

    var printDate: String? {

        Date(fromString: datetime, format: "yyyy-MM-dd'T'HH:mm:ss.SSSXXX")?.toString(format: "yyyy-MM-dd")
    }

    var printTitle: String {

        displaySitename.isEmpty ? "-" : displaySitename
    }

    var favoriteIcon: String {
        favorite ? "star.fill" : "star.leadinghalf.filled"
    }
    
    var convertBookMarkEntity: BookMarkEntity {

        return BookMarkEntity(id: id, title: printTitle, thumbnailImgUrl: thumbnailUrl, moveUrl: docUrl, registDate: Date(), type: .imageSearch)
    }
}
