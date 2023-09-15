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
    
    func fetchShoppingList(item: String) -> AnyPublisher<[RefineItem], NetworkError> {
        return Future<[RefineItem], NetworkError> { [weak self] promiss in
            guard let self else { return }
            self.service.request(target: Router.shopping(parameters: NaverShoppingQuery(item: item)), type: NaverShoppingListDTO.self)
                .sink { completion in
                    
                    if case .failure(let error) = completion {
                        switch error {
                        default:
                            promiss(.failure(error))
                        }
                    }
                    
                } receiveValue: { [weak self] shoppingListDTO in
                    guard let self else { return }

                    self.loadImage(item: shoppingListDTO)
                        .sink { completion in
                            switch completion {
                            case .finished:
                                break
                            case .failure(let error):
                                print(error)
                            }
                        } receiveValue: { list in
                            promiss(.success(list))
                        }
                        .store(in: &self.anyCancellable)
                }
                .store(in: &self.anyCancellable)
        }.eraseToAnyPublisher()
    }
    
    func loadImage(item: NaverShoppingListDTO) -> AnyPublisher<[RefineItem], Error> {
        let publishers = item.items.map { itemDTO in
            DefaultImageCacheService.shared.setImage(itemDTO.image)
                .compactMap { data in
                    return data
                }
                .map { data in
                    let filterTitle = itemDTO.title.replacingOccurrences(of: "<b>", with: "")
                    let secondFilterTitle = filterTitle.replacingOccurrences(of: "</b>", with: "")
                    return RefineItem(title: secondFilterTitle, image: data, imageURL: itemDTO.image, lprice: itemDTO.lprice, mallName: itemDTO.mallName, productId: itemDTO.productId, isSelected: false)
                }
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
}
