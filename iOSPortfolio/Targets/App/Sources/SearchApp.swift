//
//  AppSource.swift
//
//  Tuist 인식을 위한 더미 파일입니다.
//
import Foundation
import SwiftUI
import FeatureSearch

@main
struct SearchApp: App {

    @State private var selectedTab = 0 // 선택된 탭을 추적할 상태 변수
    @StateObject private var coordinator = TabCoordinator()

    init() {
        // 탭바 배경색 설정
        UITabBar.appearance().backgroundColor = UIColor.systemGray6
        // iOS 15 이상에서 배경색이 올바르게 적용되도록 설정
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray6
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                // 첫 번째 탭
                coordinator.build(type: .searchBook)
                // 비디오 검색
                coordinator.build(type: .image)
                // 북마크
                coordinator.build(type: .bookMark)
            }
            .tint(.blue)

        }

    }
}
