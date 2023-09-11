//
//  ItemDetailModelProtocol.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import Foundation
// MARK: - View State

protocol ItemDetailModelStatePotocol {
    var item: NaverShoppingItem { get }
    var routerSubject: ItemDetailRouter.Subjects { get }
}

// MARK: - Intent Actions

protocol ItemDetailModelActionsProtocol: AnyObject {
    func setupScreen(item: NaverShoppingItem)
}

// MARK: - Route

protocol ItemDetailModelRouterProtocol: AnyObject {
    func closeScreen()
}
