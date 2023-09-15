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
    @Published var loadingState: LoadingState = .loading
    @Published var category: [CategoryModel] = [CategoryModel(title: "정확도", isSelect: true), CategoryModel(title: "날짜순", isSelect: false), CategoryModel(title: "가격높은순", isSelect: false), CategoryModel(title: "가격낮은순", isSelect: false)]
    @Published var tabCase: TabCase = .search
    
    var networkAfterResponseData: [RefineItem] = []
    
    var navigationTitle = "상품 검색"
    
    var contentState: SearchTypes.Model.ContentState = .content
    
    let routerSubject = SearchRouter.Subjects()
    
    
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
    
    func setupScreen(tabCase: TabCase) {
        self.tabCase = tabCase
    }
    
    func setupScreenData(tabCase: TabCase, data: [RefineItem]) {
        if tabCase == .like {
            self.refineItemList = data
        } else {
            var newArr: [RefineItem] = []
            for ele in networkAfterResponseData {
                newArr.append(RefineItem(title: ele.title, image: ele.image, imageURL: ele.imageURL, lprice: ele.lprice, mallName: ele.mallName, productId: ele.productId, isSelected: false))
            }
            for dbItem in data {
                for responseItem in newArr {
                    if dbItem.productId == responseItem.productId {
                        responseItem.isSelected = true
                    }
                }
            }
            self.refineItemList = newArr
        }
    }
        
        func deleteItemToLikeTab(item: RefineItem) {
            var refreshArr: [RefineItem] = []
            for ele in refineItemList {
                if item.productId != ele.productId {
                    refreshArr.append(ele)
                }
            }
            
            self.refineItemList = refreshArr
        }
        
        func networkResponseDataFetchToModel(data: [RefineItem]) {
            self.networkAfterResponseData = data
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
