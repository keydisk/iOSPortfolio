//
//  ImageSearchCoordinator.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/15/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Core
import SwiftUI

public enum ImageSearchNavigationType: Hashable {
    /// 앱 검색
    case detail(url: String)

}

// 2. Key 생성
private struct ImageSearchCoordinatorKey: EnvironmentKey {
    static var defaultValue: any ImageSearchCoordinator = ImageSearchCoordinatorImpl()
}

// 3. EnvironmentValues 확장
extension EnvironmentValues {
    var coordinator: any ImageSearchCoordinator {
        get { self[ImageSearchCoordinatorKey.self] }
        set { self[ImageSearchCoordinatorKey.self] = newValue }
    }
}

public protocol ImageSearchCoordinator: CommonCoordinator where NaviElement == ImageSearchNavigationType {

}


public class ImageSearchCoordinatorImpl: ImageSearchCoordinator {

    public typealias NaviElement = ImageSearchNavigationType

    /// 네비게이션 상태
    @Published public var naviPath: [NaviElement] = []

    public init() {

    }

    @ViewBuilder
    public func makeView(type: NaviElement) -> some View {
        // ViewModel을 생성하며 의존성 주입!

        switch type {
        case .detail(url: let url):
            Text(url)
        }
    }
}
