//
//  ItemRealmDTO.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/14.
//

import Foundation
import RealmSwift
import Combine

final class ItemRealmDTO: Object {
    @Persisted(primaryKey: true) var productId: String
    @Persisted var title: String
    @Persisted var imageURL: String
    @Persisted var lprice: String
    @Persisted var mallName: String
    @Persisted var isSelected: Bool
    
    convenience init(prudcutId: String, title: String, imageURL: String, lprice: String, mallName: String, isSelected: Bool) {
        self.init()
        self.title = title
        self.productId = productId
        self.imageURL = imageURL
        self.lprice = lprice
        self.mallName = mallName
        self.isSelected = isSelected
    }
}

extension ItemRealmDTO {
    var toDoamin: RefineItem {
        var itemImage = Data()
        var cancellables = Set<AnyCancellable>()
        Publishers.MergeMany(
            DefaultImageCacheService.shared.setImage(imageURL)
                .mapError { error in
                    print("Image loading error: \(error)")
                    return error
                }
                .compactMap { data in
                    print(data, "🐕")
                    return data
                }
        )
        .collect()
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("Image loading error: \(error)")
            }
        }) { itemDTOs in
            itemImage = itemDTOs[0]
        }
        .store(in: &cancellables)
        return RefineItem(title: title, image: itemImage, imageURL: imageURL, lprice: lprice, mallName: mallName, productId: productId, isSelected: isSelected)
    }
}
