//
//  OtherStateView.swift
//  View
//
//  Created by JuYoung choi on 7/22/25.
//

import SwiftUI

/// 히스토리가 비어 있을때 사용
struct OtherStateView: View {
    
    let imageNm: String
    let text: String
    
    var body: some View {
        
        VStack(spacing: 12) {
            Image(systemName: imageNm)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64)
                .foregroundColor(.gray)
            Text(text)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            hideKeyboard()
        }
    }
}
