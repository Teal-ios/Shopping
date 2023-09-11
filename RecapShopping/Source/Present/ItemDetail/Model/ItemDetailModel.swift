//
//  ItemDetailModel.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import SwiftUI
import Combine

final class ItemDetailModel: ObservableObject, ItemDetailModelStatePotocol {
    @Published var item: NaverShoppingItem = NaverShoppingItem(title: "", link: "", image: "", lprice: "", hprice: "", mallName: "", productId: "", productType: "", brand: "", maker: "", category1: "", category2: "", category3: "", category4: "")
        
    let routerSubject = ItemDetailRouter.Subjects()

}

extension ItemDetailModel: ItemDetailModelActionsProtocol {
    func setupScreen(item: NaverShoppingItem) {
        self.item = item
    }
    
    
}

extension ItemDetailModel: ItemDetailModelRouterProtocol {
    func closeScreen() {
        routerSubject.close.send(())
    }
}
