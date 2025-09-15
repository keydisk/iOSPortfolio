//
//  ImageData.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Foundation
import Core

extension ImageElement {

    var thumbnailURL: URL? {

        URL(string: thumbnailUrl)
    }

    var printDate: String? {

        Date(fromString: datetime, format: "yyyy-MM-dd'T'HH:mm:ss.SSSXXX")?.toString(format: "yyyy-MM-dd")
    }

    var printTitle: String {

        if displaySitename.isEmpty {
            return "-"
        } else {
            return displaySitename
        }
    }
}
