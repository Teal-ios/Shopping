//
//  CategoryModel.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import Foundation

struct CategoryModel: Identifiable {
    let title: String
    let isSelect: Bool
    let id = UUID()
}
