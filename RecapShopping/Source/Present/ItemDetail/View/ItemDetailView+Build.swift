//
//  ItemDetailView+Build.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import SwiftUI

extension ItemDetailView {

    static func build(data: ItemDetailTypes.Intent.ExternalData) -> some View {
        let model = ItemDetailModel()
        let intent = ItemDetailIntent(model: model, externalData: data)
        let container = MVIContainer(
            intent: intent as ItemDetailIntentProtocol,
            model: model as ItemDetailModelStatePotocol,
            modelChangePublisher: model.objectWillChange)
        let view = ItemDetailView(container: container)
        return view
    }
}
