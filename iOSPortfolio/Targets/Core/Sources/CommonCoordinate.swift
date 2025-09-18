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

extension CommonCoordinator {
    /// 네비게이션 푸시
    /// - Parameter type: 이동 타입 푸시
    public func push(_ type: NaviElement) {
        naviPath.append(type)
    }

    /// 네비게이션 팝
    public func pop() {
        naviPath.removeLast()
    }

    /// 루트로 이동
    public func root() {
        naviPath = []
    }

    /// 네비게이션에서 특정 뷰 삭제
    public func removeView(removeOption: @escaping (NaviElement) -> Bool) {
        naviPath = naviPath.filter {
            !removeOption($0)
        }
    }
}
