//
//  RefineItemDataBaseUseCase.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/15.
//

import Foundation
import Combine

protocol RefineItemDataBaseUseCase {
    func load() -> AnyPublisher<[RefineItem], Error>
    func save(with item: RefineItem)
    func delete(with item: RefineItem)
}

final class RefineItemDataBaseUseCaseImpl: RefineItemDataBaseUseCase {
    
    let repository: RefineItemDataBaseRepository
    
    init(refineItemDataBaseRepository: RefineItemDataBaseRepository) {
        self.repository = refineItemDataBaseRepository
    }

    func load() -> AnyPublisher<[RefineItem], Error> {
        return repository.fetchItem()
    }
    
    func save(with item: RefineItem) {
        return repository.addItem(item: item)
    }
    
    func delete(with item: RefineItem) {
        return repository.deleteItem(item: item)
    }
}
