//
//  CommonCoordinate.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/14/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Combine
import SwiftUI

public protocol CommonCoordinator: ObservableObject {

    associatedtype NaviElement: Hashable
    associatedtype DestinationView: View

    var naviPath: [NaviElement] {get set}

    /// 네비게이션 푸시
    /// - Parameter type: 이동 타입 푸시
    func push(_ type: NaviElement)

    /// 네비게이션 팝
    func pop()

    /// 루트로 이동
    func root()

    /// 네비게이션에서 특정 뷰 삭제
    func removeView(removeOption: @escaping (NaviElement) -> Bool)

    @ViewBuilder
    func makeView(type: NaviElement) -> DestinationView
}
