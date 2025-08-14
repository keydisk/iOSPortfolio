//
//  ScrollEndPreferenceKey.swift
//  View
//
//  Created by JuYoung choi on 7/22/25.
//
import SwiftUI

/// 스크롤뷰 끝인지 알기 위해 사용
struct ScrollEndPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
