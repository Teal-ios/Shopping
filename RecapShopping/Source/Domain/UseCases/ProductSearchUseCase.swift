//
//  ProductSearchUseCase.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import Foundation
import Combine

protocol ProductSearchUseCase {
    func excute(item: String) -> AnyPublisher<[RefineItem], NetworkError>
}

final class ProductSearchUseCaseImpl: ProductSearchUseCase {
    
    private let productSearchRepository: ProductSearchRepository
    private var anyCancellable = Set<AnyCancellable>()
    
    init(productSearchRepository: ProductSearchRepository) {
        self.productSearchRepository = productSearchRepository
    }
    
    func excute(item: String) -> AnyPublisher<[RefineItem], NetworkError> {
        return Future<[RefineItem], NetworkError> { [weak self] promiss in
            guard let self else { return }
            self.productSearchRepository.fetchShoppingList(item: item)
                .sink { completion in

                    if case .failure(let error) = completion {
                        switch error {
                        default:
                            promiss(.failure(error))
                        }
                    }
                    
                } receiveValue: { shoppingList in
                    promiss(.success(shoppingList))
                }
                .store(in: &self.anyCancellable)
        }.eraseToAnyPublisher()
    }
}
