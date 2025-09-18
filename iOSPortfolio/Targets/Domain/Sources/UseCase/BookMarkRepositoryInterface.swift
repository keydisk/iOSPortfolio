//
//  BookMarkUseCase.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/16/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Combine

public protocol BookMarkRepository {

    func addBookMark(_ bookMark: BookMarkEntity) throws
    func getBookMark(_ keyValue: String) throws -> [BookMarkEntity]?
    func deleteBookMark(_ keyValue: String) throws

    func allValue() throws -> [BookMarkEntity]? 
    var bookmarksPublisher: AnyPublisher<[BookMarkEntity]?, Never> {get}
}
