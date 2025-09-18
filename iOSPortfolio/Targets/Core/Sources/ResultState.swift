//
//  ResultState.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/28/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Foundation
import SwiftUI

public enum ResultState<T> {

    case noSearch(Image, String)
    case empty(Image, String)
    case list(T)
    case error(NSError)
}
