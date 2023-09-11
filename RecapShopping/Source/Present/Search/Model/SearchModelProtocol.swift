//
//  SearchModelProtocol.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import SwiftUI

// MARK: - View State

protocol SearchModelStateProtocol {
    var contentState: SearchTypes.Model.ContentState { get }
    var searchText: String { get }
    var navigationTitle: String { get }
    var routerSubject: SearchRouter.Subjects { get }
    var tabCase: TabCase { get }
}

// MARK: - Intent Actions
protocol SearchModelActionsProtocol: AnyObject {
    func fetchShoppingList(contents: NaverShoppingList)
    func fetchShoppingListError(_ error: NetworkError)
}

// MARK: - Router
protocol SearchModelRouterProtocol: AnyObject {
    func routeToItemDetail(item: NaverShoppingItem)
}
