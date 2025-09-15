//
//  ImageSearchOption.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

// In Domain Layer
public protocol ImageSearchOptionProtocol: RawRepresentable, CaseIterable where RawValue == String {

    var displayName: String {get}
    var paramValue: String {get}
}

extension ImageSearchOptionProtocol {

    public var paramValue: String {
        rawValue
    }
}

public enum ImageSortingOption: String, ImageSearchOptionProtocol, Identifiable {
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
