//
//  BookMarkUseCase.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/16/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Combine

public protocol BookMarkUseCase {

    var allValues: [BookMarkEntity] { get }
    func removeElement(_ model: BookMarkEntity)
    func selectElement(_ model: BookMarkEntity)
    var bookmarksPublisher: AnyPublisher<[BookMarkEntity]?, Never> {get}

    func getFavoriteList<T: WithBookMarkList>(targetList: [T], bookMarkList: [BookMarkEntity]) -> [T]
}

public class BookMarkUseCaseImpl: BookMarkUseCase {

    private let repository: BookMarkRepository
    private let updateRepository = PassthroughSubject<[BookMarkEntity], Never>()

    public init(repository: BookMarkRepository) {

        self.repository = repository
    }

    public var bookmarksPublisher: AnyPublisher<[BookMarkEntity]?, Never> {

        repository.bookmarksPublisher
    }

    public var allValues: [BookMarkEntity] {

        do {
            return try repository.allValue() ?? []
        } catch {

        }

        return []
    }

    public func selectElement(_ model: BookMarkEntity) {
        do {
            print("model id : \(model.id)")
            try repository.addBookMark(model)
        } catch {

            print("error : \(error)")
        }

    }

    public func removeElement(_ model: BookMarkEntity) {

        do {
            try repository.deleteBookMark(model.id)
        } catch {

        }
    }

    public func getFavoriteList<T: WithBookMarkList>(targetList: [T], bookMarkList: [BookMarkEntity]) -> [T] {

        targetList.map({model in
            var model = model
            model.favorite = false

            for tmpModel in bookMarkList {

                if tmpModel.id == model.id {
                    model.favorite = true
                    break
                }
            }

            return model
        })
    }
}
