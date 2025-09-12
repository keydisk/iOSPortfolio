//
//  BookDetailViewModel.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/12/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Combine

protocol BookDetailViewModel: ObservableObject {

    func tapElement()
    var state: String { get set }
}

class BookDetailViewModelImpl: BookDetailViewModel {

    @Published var state = ""

    let useCase: BookDetailUseCase

    init(useCase: BookDetailUseCase, state: String) {
        self.useCase = useCase
        self.state = state
    }

    func tapElement() {
        
    }
}
