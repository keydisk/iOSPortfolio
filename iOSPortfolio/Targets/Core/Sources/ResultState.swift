//
//  ResultState.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/28/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Foundation
import SwiftUI

public protocol ResultWithIconMessage {

    var icon: Image {get set}
    var message: String {get set}
}

public struct ResultError: ResultWithIconMessage {

    public var icon: Image
    public var message: String

    public init(networkError: Error) {

        self.icon    = Image(systemName: "network.slash")
        self.message = (networkError as NSError).description
    }

    public init(icon: Image? = nil, message: String) {
        if let icon = icon {
            self.icon = icon
        } else {
            self.icon = Image(systemName: "network.slash")
        }

        self.message = message
    }
}

public struct ResultEmpty: ResultWithIconMessage {

    public var icon: Image
    public var message: String

    public init(icon: Image? = nil, message: String) {

        if let icon = icon {
            self.icon = icon
        } else {
            self.icon = Image(systemName: "exclamationmark.icloud")
        }

        self.message = message
    }
}

public struct NoSearchModel: ResultWithIconMessage {

    public var icon: Image
    public var message: String

    public init(icon: Image? = nil, message: String) {

        if let icon = icon {
            self.icon = icon
        } else {
            self.icon = Image(systemName: "rectangle.and.text.magnifyingglass")
        }

        self.message = message
    }
}

public enum ResultState<T> {

    case noSearch(NoSearchModel)
    case empty(ResultEmpty)
    case list(T)
    case error(ResultError)

}
