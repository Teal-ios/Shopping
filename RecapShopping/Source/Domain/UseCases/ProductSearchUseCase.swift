//
//  ProductSearchUseCase.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import Foundation
import Combine

protocol ProductSearchUseCase {
    func excute(item: String) -> AnyPublisher<NaverShoppingList, NetworkError>
}

final class ProductSearchUseCaseImpl: ProductSearchUseCase {
    
    private let productSearchRepository: ProductSearchRepository
    private var anyCancellable = Set<AnyCancellable>()
    
    init(productSearchRepository: ProductSearchRepository) {
        self.productSearchRepository = productSearchRepository
    }
    
    func excute(item: String) -> AnyPublisher<NaverShoppingList, NetworkError> {
        return Future<NaverShoppingList, NetworkError> { promiss in
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
