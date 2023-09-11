//
//  ProductSearchRepositoryImpl.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import Foundation
import Combine

final class ProductSearchRepositoryImpl: ProductSearchRepository {
    
    private let service: Service
    private var anyCancellable = Set<AnyCancellable>()
    
    init(service: Service) {
        self.service = service
    }
    
    func fetchShoppingList(item: String) -> AnyPublisher<NaverShoppingList, NetworkError> {
        return Future<NaverShoppingList, NetworkError> { promiss in
            self.service.request(target: Router.shopping(parameters: NaverShoppingQuery(item: item)), type: NaverShoppingListDTO.self)
                .sink { completion in

                    if case .failure(let error) = completion {
                        switch error {
                        default:
                            promiss(.failure(error))
                        }
                    }
                    
                } receiveValue: { shoppingListDTO in
                    let shoppingList = shoppingListDTO.toDomain
                    promiss(.success(shoppingList))
                }
                .store(in: &self.anyCancellable)
        }.eraseToAnyPublisher()
    }
}
