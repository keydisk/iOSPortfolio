//
//  MainView.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/14/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//


import Foundation
import SwiftUI
import Core

/// 책 검색 뷰
public struct MainView: View {

    @State private var title: String = ""
    public init(title: String) {

        self.title = title
    }

    public var body: some View {

        VStack {
            Text("Hello, World! \(title)")
        }

    }
}
