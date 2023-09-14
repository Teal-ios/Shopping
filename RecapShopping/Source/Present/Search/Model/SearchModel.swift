//
//  SearchModel.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import SwiftUI
import UIKit
import Combine

struct ItemDTO: Hashable {
    let title: String
    let link: String
    let image: UIImage
    let lprice: String
    let hprice: String
    let mallName: String
    let productId: String
    let productType: String
    let brand: String
    let maker: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
    let isSelected: Bool
}

final class SearchModel: ObservableObject, SearchModelStateProtocol {
    
    @Published var shoppingList: NaverShoppingList?
    
    @Published var itemDTOList: [ItemDTO] = []
    
    @Published var loadingState: LoadingState = .loading // 로딩 상태 초기값 설정
    
    @Published var category: [CategoryModel] = [CategoryModel(title: "정확도", isSelect: true), CategoryModel(title: "날짜순", isSelect: false), CategoryModel(title: "가격높은순", isSelect: false), CategoryModel(title: "가격낮은순", isSelect: false)]
    
    var navigationTitle = "상품 검색"
    
    var contentState: SearchTypes.Model.ContentState = .content
        
    let routerSubject = SearchRouter.Subjects()
    
    let tabCase: TabCase = .search
    
    private var cancellables = Set<AnyCancellable>()
    
}

extension SearchModel: SearchModelActionsProtocol {
    func fetchShoppingList(contents: NaverShoppingList) {
        self.shoppingList = contents
        self.loadImage(items: contents.items)
        print(contents, "✅")
    }
    
    func fetchShoppingListError(_ error: NetworkError) {
        contentState = .error(error: error)
    }
    
    func loadImage(items: [NaverShoppingItem]) {
        self.itemDTOList = []
        Publishers.MergeMany(items.map { item in
            DefaultImageCacheService.shared.setImage(item.image)
                .mapError { error in
                    print("Image loading error: \(error)")
                    self.loadingState = .failure // 실패 상태 설정
                    return error
                }
                .compactMap { data in
                    print(data, "🐕")
                    return UIImage(data: data)
                }
                .map { image in
                    let filterTitle = item.title.replacingOccurrences(of: "<b>", with: "")
                    let secondFilterTitle = filterTitle.replacingOccurrences(of: "</b>", with: "")
                    return ItemDTO(title: secondFilterTitle, link: item.link, image: image, lprice: item.lprice, hprice: item.hprice, mallName: item.mallName, productId: item.productId, productType: item.productType, brand: item.brand, maker: item.maker, category1: item.category1, category2: item.category2, category3: item.category3, category4: item.category4, isSelected: false)
                }
        })
        .collect()
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("Image loading error: \(error)")
                self.loadingState = .failure // 실패 상태 설정
            }
        }) { itemDTOs in
            self.itemDTOList.append(contentsOf: itemDTOs)
            self.loadingState = .success // 성공 상태 설정
        }
        .store(in: &self.cancellables)
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
