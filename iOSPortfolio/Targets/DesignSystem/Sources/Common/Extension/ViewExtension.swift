//
//  ViewExtension.swift
//  View
//
//  Created by JuYoung choi on 7/22/25.
//

import SwiftUI

extension View {
    /// 마스킹으로 코너 레디어스
    func maskingCornerRadius(_ radius: CGFloat) -> some View {
        mask(
            RoundedRectangle(cornerRadius: radius)
        )
    }
    
    /// 키보드 내리기
    func hideKeyboard() {
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
    
    
    /// 왼쪽 정렬 텍스트
    /// - Parameters:
    ///   - text: 텍스트
    ///   - type: 텍스트 꾸미기 타입
    ///   - lineLimit: 라인수 정하기
    /// - Returns: 반영된 텍스트
    func drawLeadingAignText(text: String, type: TextType, lineLimit: Int = 1) -> some View {
        
        HStack {
            Text(text)
                .lineLimit(lineLimit)
                .modifier(TextDecoration(textType: type))
                .truncationMode(.tail)
            Spacer()
        }
    }
}
