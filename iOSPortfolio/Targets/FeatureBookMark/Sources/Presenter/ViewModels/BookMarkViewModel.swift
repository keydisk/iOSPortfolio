//
//  BookMarkViewModel.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/16/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Combine
import SwiftUI
import Core
import RxCocoa
import RxSwift
import RxDataSources
import Domain

public protocol BookMarkViewModel {

    func deleteElement(_ model: BookMarkEntity)
    
    var state: BehaviorRelay<ResultState<[BookMarkItemSection]>> { get set }
    func currentListElement(index: IndexPath) -> BookMarkEntity?
}

public final class BookMarkViewModelImpl: BookMarkViewModel {

    public var state: BehaviorRelay<ResultState<[BookMarkItemSection]>> = BehaviorRelay<ResultState<[BookMarkItemSection]>>(value: .noSearch(Image(systemName: "rectangle.and.text.magnifyingglass"), "검색어를 넣어 검색해주세요."))

    let disposeBag = DisposeBag()
    var cancelable = Set<AnyCancellable>()

    private let useCase: BookMarkUseCase
    public init(useCase: BookMarkUseCase) {

        self.useCase = useCase

        Task {@MainActor [weak self] in

            self?.state.accept(.list([useCase.allValues.convertItemSection]))
        }

        dataBinding()
    }

    private func dataBinding() {

        useCase.bookmarksPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] list in

                guard let list = list else {
                    return
                }

                self?.state.accept(.list([list.convertItemSection] ) )
            }).store(in: &cancelable)
    }

    public func currentListElement(index: IndexPath) -> BookMarkEntity? {
        guard case .list(let result) = state.value else {
            return nil
        }

        return result[index.section].items[index.row]
    }

    public func deleteElement(_ model: BookMarkEntity) {

        Observable.just(())
            .do(onNext: { [weak self] _ in
                self?.useCase.removeElement(model)
            })
            .map { [weak self] () -> [BookMarkEntity]? in

                return self?.useCase.allValues
            }
            .filter { list in
                if let list = list {
                    return list.count > 0
                } else {
                    return false
                }
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] list in

                self?.state.accept(.list([list!.convertItemSection]))
            })
            .disposed(by: disposeBag)
    }
}
