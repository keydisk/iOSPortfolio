//
//  BookMarkCoordinator.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/16/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import UIKit
import Core

public enum BookMarkNavigationType: Hashable {
    /// 앱 검색
    case detail(url: String)

}

public protocol BookMarkCoordinator {

    var navigationController: UINavigationController {get set}
    func push(type: BookMarkNavigationType)
    func pop()
    func popRoot()

    func removeViewCtr(filterOption: @escaping (UIViewController) -> Bool)
}

public class BookMarkCoordinatorImpl: BookMarkCoordinator {

    public typealias NaviElement = BookMarkNavigationType

    public var navigationController: UINavigationController

    public init(naviCtr: UINavigationController) {

        navigationController = naviCtr
    }

    public func push(type: BookMarkNavigationType) {

        navigationController.pushViewController(makeView(type: type), animated: true)
    }

    public func pop() {

        navigationController.popViewController(animated: true)
    }

    public func popRoot() {
        navigationController.popToRootViewController(animated: true)
    }

    public func removeViewCtr(filterOption: @escaping (UIViewController) -> Bool) {

        navigationController.viewControllers = navigationController.viewControllers.filter(filterOption)
    }

    private func makeView(type: BookMarkNavigationType) -> UIViewController {
        switch type {
        case .detail(url: let url):
            BookMarkDetailViewController(url: url, coordinator: self)
        }
    }
}
