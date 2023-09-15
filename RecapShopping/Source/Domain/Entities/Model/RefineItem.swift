//
//  RefineItem.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/14.
//

import Foundation

final class RefineItem {
    
    let title: String
    let image: Data
    let imageURL: String
    let lprice: String
    let mallName: String
    let productId: String
    var isSelected: Bool
    
    init(title: String, image: Data, imageURL: String, lprice: String, mallName: String, productId: String, isSelected: Bool) {
        self.title = title
        self.image = image
        self.imageURL = imageURL
        self.lprice = lprice
        self.mallName = mallName
        self.productId = productId
        self.isSelected = isSelected
    }
}

extension RefineItem {
    var toData: ItemRealmDTO {
        return ItemRealmDTO(productId: productId, title: title, imageURL: imageURL, lprice: lprice, mallName: mallName, isSelected: isSelected)
    }
}
