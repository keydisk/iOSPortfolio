//
//  StatePrintView.swift
//  DesignSystem
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import SwiftUI

public struct StatePrintView: View {

    let iconImage: Image
    let title: String

    public init(iconImage: Image, title: String) {

        self.iconImage = iconImage
        self.title = title
    }

    public var body: some View {

        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {

                    Spacer()
                    iconImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width / 8)
                    Text(title)
                        .padding(.top, 5)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    StatePrintView(iconImage: Image(systemName: "rectangle.and.text.magnifyingglass"), title: "검색어를 입력하세요")
}
