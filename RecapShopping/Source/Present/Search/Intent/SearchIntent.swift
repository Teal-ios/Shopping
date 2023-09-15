//
//  SearchIntent.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import SwiftUI
import Combine

import RealmSwift

class SearchIntent {

    private var cancellable = Set<AnyCancellable>()
    // MARK: Model

    private weak var model: SearchModelActionsProtocol?
    private weak var routeModel: SearchModelRouterProtocol?

    // MARK: Services

    private let productShoppingUseCase: ProductSearchUseCaseImpl
    private let refineDataBaseUseCase: RefineItemDataBaseUseCaseImpl

    // MARK: Business Data

    private let externalData: SearchTypes.Intent.ExternalData
    private var contents: [RefineItem] = []
    private var text: String = ""
    private var searchList: [RefineItem] = []

    // MARK: Life cycle

    init(model: SearchModelActionsProtocol & SearchModelRouterProtocol,
         externalData: SearchTypes.Intent.ExternalData,
         productShoppingUseCase: ProductSearchUseCaseImpl, refineDataBaseUseCase: RefineItemDataBaseUseCaseImpl) {
        self.externalData = externalData
        self.model = model
        self.routeModel = model
        self.productShoppingUseCase = productShoppingUseCase
        self.refineDataBaseUseCase = refineDataBaseUseCase
    }
    
    var itemValidTrigger = CurrentValueSubject<Bool, Never>(false)
}

// MARK: - Public

extension SearchIntent: SearchIntentProtocol {
    func searchTextToIntent(text: String) {
        self.text = text
    }
    
    
    func viewOnAppear() {
        print("✅✅✅",Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func likeButtonTapped(item: RefineItem) {
        
        for ele in searchList {
            if ele.productId == item.productId {
                ele.isSelected.toggle()
            }
        }
        if searchList.count != 0 {
            self.model?.fetchShoppingList(contents: searchList)
        }
        
        refineDataBaseUseCase.load()
            .sink { error in
                print(error)
            } receiveValue: { [weak self] itemList in
                guard let self else { return }
                var validTrigger = false
                for ele in itemList {
                    if ele.productId == item.productId {
                        self.refineDataBaseUseCase.delete(with: item)
                        validTrigger = true
                        for intent in searchList {
                            if intent.productId == ele.productId {
                                intent.isSelected = false
                            }
                        }
                    }
                }
                
                if !validTrigger {
                    self.refineDataBaseUseCase.repository.addItem(item: item)
                    for ele in searchList {
                        if ele.productId == item.productId {
                            ele.isSelected = true
                        }
                    }
                }
            }
            .store(in: &cancellable)

    }
    
    func categoryButtonTapped(category: CategoryModel) {
        print("카테고리클릭")
    }
    
    func searchKeyboardButtonTapped() {
        productShoppingUseCase.excute(item: text)
            .sink { [weak self] error in
                guard let self else { return }
                print(error)
            } receiveValue: { [weak self] shoppingList in
                guard let self else { return }
                print(shoppingList)
                if !shoppingList.isEmpty {
                    refineDataBaseUseCase.load()
                        .sink { error in
                            print(error)
                        } receiveValue: { refineList in
                            for dbItem in refineList {
                                for responseItem in shoppingList {
                                    if dbItem.productId == responseItem.productId {
                                        responseItem.isSelected = true
                                    }
                                }
                            }
                            self.model?.fetchShoppingList(contents: shoppingList)
                            self.searchList = shoppingList
                        }
                        .store(in: &cancellable)
                }
            }
            .store(in: &cancellable)

    }
}

// MARK: - Helper classes

extension SearchTypes.Intent {
    struct ExternalData { }
}
