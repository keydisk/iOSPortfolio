//
//  CustomNaviView.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/14/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import SwiftUI

struct CustomNaviView: ViewModifier {

    @Environment(\.dismiss) var dismiss

    let title: String

    func body(content: Content) -> some View {
        VStack {

            HStack {
                Spacer()
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            
            content
        }
    }
}
