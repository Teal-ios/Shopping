//
//  NaverShoppingListDTO.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import Foundation

struct NaverShoppingListDTO: Decodable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [NaverShoppingItemDTO]
    
    enum CodingKeys: String, CodingKey {
        case lastBuildDate, total, start, display, items
    }
}

extension NaverShoppingListDTO {
//    var toDomain: NaverShoppingList {
//        return .init(lastBuildDate: lastBuildDate, total: total, start: start, display: display, items: items.map { $0.toDomain })
//    }
}
