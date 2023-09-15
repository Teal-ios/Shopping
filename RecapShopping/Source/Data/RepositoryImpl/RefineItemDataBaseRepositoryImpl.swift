//
//  RefineItemDataBaseRepositoryImpl.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/15.
//

import Foundation
import Combine

import RealmSwift


final class RefineItemDataBaseRepositoryImpl: RefineItemDataBaseRepository {
    
    let storage = try! Realm()
    
    private var anyCancellable = Set<AnyCancellable>()

    func fetchItem() -> AnyPublisher<[RefineItem], Error> {
        self.cacheImage(item: storage.objects(ItemRealmDTO.self).toArray)
    }
    
    func deleteItem(item: RefineItem) {
        if let dbItem = storage.objects(ItemRealmDTO.self).first(where: { $0.productId == item.productId }) {
            do {
                try storage.write {
                    storage.delete(dbItem)
                }
            } catch let error {
                print("Delete error: \(error.localizedDescription)")
            }
        }
    }
    
    func addItem(item: RefineItem) {
        do {
            try storage.write {
                storage.add(itemToData(item: item))
            }
        } catch let error {
            print("Add error: \(error.localizedDescription)")
        }
    }
}

extension RefineItemDataBaseRepositoryImpl {
    private func itemToData(item: RefineItem) -> ItemRealmDTO {
        ItemRealmDTO(productId: item.productId, title: item.title, imageURL: item.imageURL, lprice: item.lprice, mallName: item.mallName, isSelected: item.isSelected)
    }
    
    private func cacheImage(item: [ItemRealmDTO]) -> AnyPublisher<[RefineItem], Error> {
        let publishers = item.map { itemDTO in
            DefaultImageCacheService.shared.setImage(itemDTO.imageURL)
                .compactMap { data in
                    return data
                }
                .map { data in
                    return RefineItem(title: itemDTO.title, image: data, imageURL: itemDTO.imageURL, lprice: itemDTO.lprice, mallName: itemDTO.mallName, productId: itemDTO.productId, isSelected: itemDTO.isSelected)
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
