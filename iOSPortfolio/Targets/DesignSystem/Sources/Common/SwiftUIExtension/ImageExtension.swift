//
//  ImageExtension.swift
//  View
//
//  Created by JuYoung choi on 7/22/25.
//

import SwiftUI


extension Image {
    /// 현재 타겟안에서 이미지 불러오기 위해 사용
    init(name: String) {

        self = Image(name, bundle: .module )
    }
        
}
