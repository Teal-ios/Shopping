//
//  MVIContainers.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import SwiftUI
import Combine

final class MVIContainer<Intent, Model>: ObservableObject {

    // MARK: Public

    let intent: Intent
    let model: Model

    // MARK: private

    private var cancellable: Set<AnyCancellable> = []

    // MARK: Life cycle

    init(intent: Intent, model: Model, modelChangePublisher: ObjectWillChangePublisher) {
        self.intent = intent
        self.model = model

        modelChangePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellable)
    }
}
