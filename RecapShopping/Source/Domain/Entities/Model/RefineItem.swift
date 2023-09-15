//
//  RefineItem.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/14.
//

import Foundation

struct RefineItem: Hashable {
    let title: String
    let image: Data
    let imageURL: String
    let lprice: String
    let mallName: String
    let productId: String
    let isSelected: Bool
}

extension RefineItem {
    var toData: ItemRealmDTO {
        return ItemRealmDTO(prudcutId: productId, title: title, imageURL: imageURL, lprice: lprice, mallName: mallName, isSelected: isSelected)
    }
}
