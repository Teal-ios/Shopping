//
//  NaverShoppingList.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import Foundation

struct NaverShoppingList: Hashable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [NaverShoppingItem]
}
