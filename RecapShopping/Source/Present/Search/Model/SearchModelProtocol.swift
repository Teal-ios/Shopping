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
    var navigationTitle: String { get }
    var refineItemList: [RefineItem] { get }
    var routerSubject: SearchRouter.Subjects { get }
    var tabCase: TabCase { get }
    var loadingState: LoadingState { get }
    var category: [CategoryModel] { get }
}

// MARK: - Intent Actions
protocol SearchModelActionsProtocol: AnyObject {
    func fetchShoppingList(contents: [RefineItem])
    func fetchShoppingListError(_ error: NetworkError)
}

// MARK: - Router
protocol SearchModelRouterProtocol: AnyObject {
    func routeToItemDetail(item: NaverShoppingItem)
}
