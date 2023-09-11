//
//  ItemDetailView.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import SwiftUI

struct ItemDetailView: View {
    
    @StateObject var container: MVIContainer<ItemDetailIntentProtocol, ItemDetailModelStatePotocol>
    
    private var intent: ItemDetailIntentProtocol { container.intent }
    private var state: ItemDetailModelStatePotocol { container.model }

    var body: some View {
        bodyView()
            .onAppear(perform: intent.viewOnAppear)
            .navigationBarTitle(state.item.title, displayMode: .inline)
            .modifier(ItemDetailRouter(subjects: state.routerSubject, intent: intent))
            .onDisappear(perform: intent.viewOnDisappear)
    }
}

// MARK: - Views

private extension ItemDetailView {
    
    func bodyView() -> some View {
        VStack {
            Text(state.item.title)
        }
    }
}


struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {

        return ItemDetailView.build(data: .init(item: NaverShoppingItem(title: "asdf", link: "", image: "", lprice: "", hprice: "", mallName: "", productId: "", productType: "", brand: "", maker: "", category1: "", category2: "", category3: "", category4: "")))
    }
}
