//
//  SearchModel.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import SwiftUI
import Combine

final class SearchModel: ObservableObject, SearchModelStateProtocol {
        
    @Published var refineItemList: [RefineItem] = []
    
    @Published var loadingState: LoadingState = .loading // 로딩 상태 초기값 설정
    
    @Published var category: [CategoryModel] = [CategoryModel(title: "정확도", isSelect: true), CategoryModel(title: "날짜순", isSelect: false), CategoryModel(title: "가격높은순", isSelect: false), CategoryModel(title: "가격낮은순", isSelect: false)]
    
    var navigationTitle = "상품 검색"
    
    var contentState: SearchTypes.Model.ContentState = .content
    
    let routerSubject = SearchRouter.Subjects()
    
    let tabCase: TabCase = .search
    
    private var cancellables = Set<AnyCancellable>()
    
}

extension SearchModel: SearchModelActionsProtocol {
    func fetchShoppingList(contents: [RefineItem]) {
        self.refineItemList = []
        for ele in contents {

            self.refineItemList.append(RefineItem(title: ele.title, image: ele.image, imageURL: ele.imageURL, lprice: ele.lprice, mallName: ele.mallName, productId: ele.productId, isSelected: ele.isSelected))
        }
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
