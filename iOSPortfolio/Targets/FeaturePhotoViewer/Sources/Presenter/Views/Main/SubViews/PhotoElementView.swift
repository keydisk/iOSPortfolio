//
//  PhotoElementView.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/26/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import SwiftUI

struct PhotoElementView: View {

    let model: PhotoEntity

    var body: some View {

        if let img = model.image {
            Image(uiImage: img)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "person.crop.rectangle")
        }
    }
}
