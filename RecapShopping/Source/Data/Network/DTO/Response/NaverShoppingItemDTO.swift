//
//  NaverShoppingItemDTO.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import Foundation
import Combine

struct NaverShoppingItemDTO: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let hprice: String
    let mallName: String
    let productId: String
    let productType: String
    let brand: String
    let maker: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
}

extension NaverShoppingItemDTO {
//    var toDomain: NaverShoppingItem {
//        return .init(title: title, link: link, image: image, lprice: lprice, hprice: hprice, mallName: mallName, productId: productId, productType: productType, brand: brand, maker: maker, category1: category1, category2: category2, category3: category3, category4: category4)
//    }
//
//    var toDomainToRefineItem: AnyPublisher<RefineItem, Error> {
//        let defaultImageCacheService = DefaultImageCacheService.shared
//
//        return defaultImageCacheService.setImage(image)
//            .mapError { error in
//                print("Image loading error: \(error)")
//                return error
//            }
//            .compactMap { data in
//                print(data, "🐕")
//                return data
//            }
//            .map { itemImage in
//                RefineItem(title: self.title,
//                           image: itemImage,
//                           imageURL: self.image,
//                           lprice: self.lprice,
//                           mallName: self.mallName,
//                           productId: self.productId,
//                           isSelected: false)
//            }
//            .eraseToAnyPublisher()
//    }
}
