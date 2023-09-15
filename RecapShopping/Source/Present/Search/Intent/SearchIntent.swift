//
//  SearchIntent.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import SwiftUI
import Combine

class SearchIntent {

    private var cancellable = Set<AnyCancellable>()
    // MARK: Model

    private weak var model: SearchModelActionsProtocol?
    private weak var routeModel: SearchModelRouterProtocol?

    // MARK: Services

    private let productShoppingUseCase: ProductSearchUseCaseImpl

    // MARK: Business Data

    private let externalData: SearchTypes.Intent.ExternalData
    private var contents: [RefineItem] = []
    private var text: String = ""

    // MARK: Life cycle

    init(model: SearchModelActionsProtocol & SearchModelRouterProtocol,
         externalData: SearchTypes.Intent.ExternalData,
         productShoppingUseCase: ProductSearchUseCaseImpl) {
        self.externalData = externalData
        self.model = model
        self.routeModel = model
        self.productShoppingUseCase = productShoppingUseCase
    }
}

// MARK: - Public

extension SearchIntent: SearchIntentProtocol {
    func searchTextToIntent(text: String) {
        self.text = text
    }
    
    
    func viewOnAppear() {
        print("뷰뜸")
    }
    
    func searchKeyboardButtonTapped() {
        productShoppingUseCase.excute(item: text)
            .sink { [weak self] error in
                guard let self else { return }
                print(error)
            } receiveValue: { [weak self] shoppingList in
                guard let self else { return }
                print(shoppingList)
                self.model?.fetchShoppingList(contents: shoppingList)
                
            }
            .store(in: &cancellable)

    }
}

// MARK: - Helper classes

extension SearchTypes.Intent {
    struct ExternalData { }
}
