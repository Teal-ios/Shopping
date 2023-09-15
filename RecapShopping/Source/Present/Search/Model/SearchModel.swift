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
            let filterTitle = ele.title.replacingOccurrences(of: "<b>", with: "")
            let secondFilterTitle = filterTitle.replacingOccurrences(of: "</b>", with: "")
            self.refineItemList.append(RefineItem(title: secondFilterTitle, image: ele.image, imageURL: ele.imageURL, lprice: ele.lprice, mallName: ele.mallName, productId: ele.productId, isSelected: ele.isSelected))
        }
        print(contents, "✅")
    }
    
    func fetchShoppingListError(_ error: NetworkError) {
        contentState = .error(error: error)
    }
    
    //    func loadImage(items: [RefineItem]) {
    //        self.refineItemList = []
    //        Publishers.MergeMany(items.map { item in
    //            DefaultImageCacheService.shared.setImage(item.imageURL)
    //                .mapError { error in
    //                    print("Image loading error: \(error)")
    //                    self.loadingState = .failure // 실패 상태 설정
    //                    return error
    //                }
    //                .compactMap { data in
    //                    print(data, "🐕")
    //                    return data
    //                }
    //                .map { image in
    //                    let filterTitle = item.title.replacingOccurrences(of: "<b>", with: "")
    //                    let secondFilterTitle = filterTitle.replacingOccurrences(of: "</b>", with: "")
    //                    return RefineItem(title: secondFilterTitle, image: image, lprice: item.lprice, mallName: item.mallName, productId: item.productId, isSelected: false)
    //                }
    //        })
    //        .collect()
    //        .sink(receiveCompletion: { completion in
    //            switch completion {
    //            case .finished:
    //                break
    //            case .failure(let error):
    //                print("Image loading error: \(error)")
    //                self.loadingState = .failure // 실패 상태 설정
    //            }
    //        }) { itemDTOs in
    //            self.refineItemList.append(contentsOf: itemDTOs)
    //            self.loadingState = .success // 성공 상태 설정
    //        }
    //        .store(in: &self.cancellables)
    //    }
    
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
