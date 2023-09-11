//
//  SearchModel.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import SwiftUI
import Combine

final class SearchModel: ObservableObject, SearchModelStateProtocol {
    
    @Published var shoppingList: NaverShoppingList?
    
    var navigationTitle = "상품 검색"
    
    var contentState: SearchTypes.Model.ContentState = .content
        
    let routerSubject = SearchRouter.Subjects()
    
    let tabCase: TabCase = .search
    
}

extension SearchModel: SearchModelActionsProtocol {
    func fetchShoppingList(contents: NaverShoppingList) {
        self.shoppingList = contents
        print(contents, "✅")
    }
    
    func fetchShoppingListError(_ error: NetworkError) {
        contentState = .error(error: error)
    }
    
    
}

extension SearchModel: SearchModelRouterProtocol {
    func routeToItemDetail(item: NaverShoppingItem) {
        routerSubject.screen.send(.itemDetail(item: item))
    }
}

extension SearchTypes.Model {
    enum ContentState {
        case content
        case error(error: NetworkError)
    }
}
