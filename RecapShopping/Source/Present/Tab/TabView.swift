//
//  TabView.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            SearchView(tabCase: .search, searchText: .constant("cody"))
              .tabItem {
                Image(systemName: "1.square.fill")
                  Text("검색")
              }
            SearchView(tabCase: .like , searchText: .constant("cody"))
              .tabItem {
                Image(systemName: "heart")
                Text("좋아요")
              }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
