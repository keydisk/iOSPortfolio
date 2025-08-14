//
//  TextDecoration.swift
//  View
//
//  Created by JuYoung choi on 7/22/25.
//
import SwiftUI

enum TextType {
    case caption
    case title
    case subTitle
    case contents
    case other
}

/// 텍스트에 폰트나 컬러로 꾸미기
struct TextDecoration: ViewModifier {
    
    let textType: TextType
    
    func body(content: Content) -> some View {
        
        switch textType {
        case .caption:
            content
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(.primary)
        case .title:
            content
                .font(.system(size: 15, weight: .bold, design: .default))
                .foregroundColor(.primary)
        case .contents:
            content
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
        case .other:
            content
                .font(.system(size: 12, weight: .light, design: .monospaced))
                .foregroundColor(.secondary)
        case .subTitle:
            content
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.secondary)
        }
    }
}
