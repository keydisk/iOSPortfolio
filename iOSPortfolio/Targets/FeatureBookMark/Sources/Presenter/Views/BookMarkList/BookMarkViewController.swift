//
//  BookMarkViewController.swift
//  FeatureBookMark
//
//  Created by JuYoung choi on 9/16/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import SwiftUI
import Core
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Domain

public struct BookMarkViewControllerWrapper: UIViewControllerRepresentable {

    let viewModel: BookMarkViewModel

    public init(viewModel: BookMarkViewModel) {

        self.viewModel   = viewModel
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> UINavigationController {

        let navigationController = UINavigationController()

        // 2. 우리의 BookMarkCoordinatorImpl을 생성하고 NavController를 주입합니다.
        let coordinator = BookMarkCoordinatorImpl(naviCtr: navigationController)

        let bookMarkViewCtr = BookMarkViewController(viewModel: viewModel, coordi: coordinator)
        navigationController.pushViewController(bookMarkViewCtr, animated: false)

        // 4. Coordinator의 생명주기를 위해 context.coordinator에 저장합니다.
        context.coordinator.coordinator = coordinator

        // 5. SwiftUI 뷰 계층에 UINavigationController를 반환합니다.
        return navigationController
    }

    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // SwiftUI 상태 바뀔 때 업데이트 처리 필요시 여기에 작성
    }

    public class Coordinator: NSObject {
        var parent: BookMarkViewControllerWrapper
        var coordinator: BookMarkCoordinator?

        init(_ parent: BookMarkViewControllerWrapper) {
            self.parent = parent
        }
    }
}


public class BookMarkViewController: UIViewController {

    let viewModel: BookMarkViewModel

    let coordinator: (any BookMarkCoordinator)
    let tableView: UITableView
    let disposeBag = DisposeBag()


    public init(viewModel: BookMarkViewModel, coordi: (any BookMarkCoordinator)) {

        self.viewModel = viewModel
        self.coordinator = coordi
        tableView   = UITableView()
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func drawUI() {

        navigationItem.title = "북마크"

        tableView.separatorStyle = .none

        view.addSubview(tableView)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        tableView.snp.makeConstraints({m in

            m.edges.equalToSuperview()
        })

        tableView.accessibilityIdentifier = "BookMarkViewList"
    }

    private func bindTableView() {
        let animationConfig = AnimationConfiguration(
            insertAnimation: .bottom,
            reloadAnimation: .fade,
            deleteAnimation: .left
        )

        tableView.register(BookMarkCell.self, forCellReuseIdentifier: BookMarkCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")

        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .compactMap({[weak self] indexPath -> BookMarkEntity? in
                self?.viewModel.currentListElement(index: indexPath)
            })
            .map({model -> BookMarkNavigationType in
                .detail(url: model.moveUrl)
            })
            .bind(onNext: {[weak self] type in

                self?.coordinator.push(type: type)
            }).disposed(by: disposeBag)

        dataSet(animationConfig)
    }

    private func dataSet(_ animationConfig: AnimationConfiguration) {
        let dataSource = RxTableViewSectionedAnimatedDataSource<BookMarkItemSection>(
            animationConfiguration: animationConfig,
            configureCell: { _, tableView, indexPath, item in

                if let cell = tableView.dequeueReusableCell(withIdentifier: BookMarkCell.identifier, for: indexPath) as? BookMarkCell {

                    cell.configure(model: item)
                    cell.onLayoutUpdateNeeded = {

                        DispatchQueue.main.async {
                            // 현재의 데이터 소스 업데이트가 모두 끝난 후, 다음 차례에 레이아웃을 업데이트하도록 예약합니다.
                            UIView.performWithoutAnimation {
                                tableView.beginUpdates()
                                tableView.endUpdates()
                            }

                        }
                    }

                    cell.accessibilityIdentifier = "bookMarkCell"

                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
                    return cell
                }


            },
            canEditRowAtIndexPath: { _, _ in
                return true
            }
        )

        viewModel.state
            .compactMap({state -> [BookMarkItemSection]? in
                if case .list(let t) = state {
                    return t
                } else {
                    return []
                }
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        drawUI()
        bindTableView()
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}

extension BookMarkViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completion) in

            guard case .list(let models) = self?.viewModel.state.value else {
                return
            }

            self?.viewModel.deleteElement(models[indexPath.section].items[indexPath.row])
            completion(true)
        }

        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
