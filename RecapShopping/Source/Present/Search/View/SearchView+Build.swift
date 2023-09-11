//
//  SearchView+Build.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import SwiftUI

extension SearchView {

    static func build(data: SearchTypes.Intent.ExternalData) -> some View {
        let model = SearchModel()
        let service = ServiceImpl.shared
        let productRepositoryImpl = ProductSearchRepositoryImpl(service: service)
        let productUseCaseImpl = ProductSearchUseCaseImpl(productSearchRepository: productRepositoryImpl)
        let intent = SearchIntent(model: model, externalData: data, productShoppingUseCase: productUseCaseImpl)
        let container = MVIContainer(
            intent: intent as SearchIntentProtocol,
            model: model as SearchModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        let view = SearchView(container: container)
        return view
    }
}
