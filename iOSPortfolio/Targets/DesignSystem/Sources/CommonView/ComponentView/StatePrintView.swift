//
//  StatePrintView.swift
//  DesignSystem
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import SwiftUI
import Core

public struct StatePrintView: View {

    let iconImage: Image
    let title: String

    public init(stateModel: ResultWithIconMessage) {

        self.iconImage = stateModel.icon
        self.title = stateModel.message
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
