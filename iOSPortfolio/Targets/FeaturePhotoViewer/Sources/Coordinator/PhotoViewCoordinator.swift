//
//  Coordinator.swift
//  FeaturePhotoViewer
//
//  Tuist 인식을 위한 더미 파일입니다.
//
import Foundation
import SwiftUI
import Core

public enum PhotoViewNavigationType: Hashable {
    /// 앱 검색
    case detail(url: String)

}

// 2. Key 생성
private struct PhotoViewCoordinatorKey: EnvironmentKey {
    static var defaultValue: any PhotoViewCoordinator = PhotoViewCoordinatorImpl()
}

// 3. EnvironmentValues 확장
extension EnvironmentValues {
    var coordinator: any PhotoViewCoordinator {
        get { self[PhotoViewCoordinatorKey.self] }
        set { self[PhotoViewCoordinatorKey.self] = newValue }
    }
}

public protocol PhotoViewCoordinator: CommonCoordinator where NaviElement == PhotoViewNavigationType {
}

public class PhotoViewCoordinatorImpl: PhotoViewCoordinator {

    public typealias NaviElement = PhotoViewNavigationType

    /// 네비게이션 상태
    @Published public var naviPath: [NaviElement] = []

    public init() {

    }

    @ViewBuilder
    public func makeView(type: NaviElement) -> some View {
        // ViewModel을 생성하며 의존성 주입!
        
        switch type {
        case .detail(url: let url):
            Text("")
        }
    }
}
