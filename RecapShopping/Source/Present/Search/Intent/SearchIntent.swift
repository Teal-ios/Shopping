//
//  SearchIntent.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import SwiftUI

class SearchIntent {

    // MARK: Model

    private weak var model: SearchModelActionsProtocol?
    private weak var routeModel: SearchModelRouterProtocol?

    // MARK: Services

    private let productShoppingUseCase: ProductSearchUseCaseImpl

    // MARK: Business Data

    private let externalData: SearchTypes.Intent.ExternalData
    private var contents: NaverShoppingList? = nil

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
    func viewOnAppear() {
        print("뷰뜸")
    }
}

// MARK: - Helper classes

extension SearchTypes.Intent {
    struct ExternalData {}
}
