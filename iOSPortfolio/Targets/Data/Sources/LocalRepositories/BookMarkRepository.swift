//
//  BookMarkRepository.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/16/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import Foundation
import RealmSwift
import Domain
import Combine

public class BookMarkRepositoryImpl: BookMarkRepository {

//    let bookMarkResult: Results<BookMarkData>?

    private let bookmarksUpdateSubject = PassthroughSubject<[BookMarkEntity]?, Never>()

    public var bookmarksPublisher: AnyPublisher<[BookMarkEntity]?, Never> {
        bookmarksUpdateSubject.eraseToAnyPublisher()
    }


    public init() {


    }

    public func addBookMark(_ bookMark: BookMarkEntity) throws {

        let realm = try Realm()

        try realm.write({[weak self] in

            realm.add(BookMarkData(id: bookMark.id, title: bookMark.title, thumbnailUrl: bookMark.thumbnailImgUrl, moveUrl: bookMark.moveUrl, type: bookMark.type.rawValue), update: .modified )
            self?.bookmarksUpdateSubject.send(try self?.allValue() )
        })
    }
    
    public func allValue() throws -> [BookMarkEntity]? {

        let realm = try Realm()

        return realm.objects(BookMarkData.self).map({model in
            model.convertEntity
        })
    }

    public func getBookMark(_ keyValue: String) throws -> [BookMarkEntity]? {

        let realm = try Realm()

        return realm.objects(BookMarkData.self)
            .filter({$0.id == keyValue})
            .map({model in

                model.convertEntity
            })
    }

    public func deleteBookMark(_ keyValue: String) throws {

        let realm = try Realm()

        let predicate = NSPredicate(format: "id = %@", keyValue)
        try realm.write({
            realm.delete(realm.objects(BookMarkData.self).filter(predicate) )
        })
        
        self.bookmarksUpdateSubject.send(try self.allValue())
    }
}
