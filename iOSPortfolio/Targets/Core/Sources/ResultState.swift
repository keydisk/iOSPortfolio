//
//  ResultState.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/28/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Foundation

public enum ResultState<T> {

    case noSearch
    case empty
    case list([T])
    case error(NSError)
}
