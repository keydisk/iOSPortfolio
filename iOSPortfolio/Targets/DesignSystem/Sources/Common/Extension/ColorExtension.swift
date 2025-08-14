//
//  ColorExtension.swift
//  View
//
//  Created by JuYoung choi on 7/22/25.
//

import SwiftUI

/// 컬러
extension Color {
    
    init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Int = 100) {

        self.init(red: Double(red) / 255.0, green: Double(green) / 255.0, blue: Double(blue) / 255.0, opacity: Double(alpha) / 100)
    }

    init(rgb: (Int, Int, Int)) {

        self.init(red: Double(rgb.0) / 255.0, green: Double(rgb.1) / 255.0, blue: Double(rgb.2) / 255.0)
    }
}
