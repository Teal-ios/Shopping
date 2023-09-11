//
//  ItemDetailIntent.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import SwiftUI

class ItemDetailIntent {
    // MARK: Model

    private weak var model: ItemDetailModelActionsProtocol?
    private weak var routeModel: ItemDetailModelRouterProtocol?

    // MARK: Business Data

    private let externalData: ItemDetailTypes.Intent.ExternalData

    // MARK: Life cycle

    init(model: ItemDetailModelActionsProtocol & ItemDetailModelRouterProtocol,
         externalData: ItemDetailTypes.Intent.ExternalData) {
        self.externalData = externalData
        self.model = model
        self.routeModel = model
    }
}

// MARK: - Public

extension ItemDetailIntent: ItemDetailIntentProtocol {

    func viewOnAppear() {
        model?.setupScreen(item: externalData.item)
    }

    func viewOnDisappear() {
    }
}

// MARK: - Helper classes

extension ItemDetailTypes.Intent {
    struct ExternalData {
        let item: NaverShoppingItem
    }
}
