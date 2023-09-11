//
//  SearchView.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import SwiftUI
import Combine

enum TabCase {
    case search
    case like
}

struct SearchView: View {
    
    @StateObject var container: MVIContainer<SearchIntentProtocol, SearchModelStateProtocol>
    
    private var intent: SearchIntentProtocol { container.intent }
    private var state: SearchModelStateProtocol { container.model }
        
    let rows = [GridItem(.flexible()), GridItem(.flexible())]
    let categoryLayout = [GridItem(.flexible())]
    
    let colors: [Color] = [.black, .blue, .brown, .cyan, .gray, .indigo, .mint, .yellow, .orange, .purple]
    
//    let shoppingList = CurrentValueSubject<NaverShoppingList?, NetworkError>(nil)
            
    let category: [CategoryModel] = [CategoryModel(title: "정확도", isSelect: true), CategoryModel(title: "날짜순", isSelect: false), CategoryModel(title: "가격높은순", isSelect: false), CategoryModel(title: "가격낮은순", isSelect: false)]
    
    @State var searchText: String = ""
    
    var body: some View {
        bodyView()
            .onAppear(perform: intent.viewOnAppear)
            .navigationBarTitle(state.navigationTitle, displayMode: .inline)
            .modifier(SearchRouter(subjects: state.routerSubject, intent: intent))
    }
}

private extension SearchView {
    func bodyView() -> some View {
        return VStack {
            Text("쇼핑 검색")
                .bold()
            HStack {
                ZStack {
                    
                    TextField("검색어를 입력하세요", text: $searchText)
                        .padding()
                        .padding(.horizontal, 25)
                        .background(Color.gray)
                        .cornerRadius(8)
                        .keyboardType(.default)
                        .onSubmit {
                            intent.searchTextToIntent(text: searchText)
                            intent.searchKeyboardButtonTapped()
                        }
                        
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .padding([.leading])
                        
                        Spacer()
                        
                        Button {
                            print("button")
                        } label: {
                            Image(systemName: "x.circle.fill")
                        }
                        .foregroundColor(.black)
                        .padding([.trailing])
                    }
                }
                Button("취소") {
                    print("취소")
                }
                .foregroundColor(.black)
            }
            .padding()
            if container.model.tabCase == .search {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(category, id: \.id) { category in
                            Button {
                                print("카테고리클릭")
                            } label: {
                                if category.isSelect == true {
                                    Text(category.title)
                                        .background(Color.white)
                                        .frame(height: 32)
                                        .foregroundColor(.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray,lineWidth:1)
                                          )
                                    
                                    
                                } else {
                                    Text(category.title)
                                        .foregroundColor(.gray)
                                        .frame(height: 32)
                                        .background(Color.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray,lineWidth:1)
                                          )
                                }
                            }
                        }
                    }
                    .padding()
                }
                .frame(height: 24)
            }
            
            ScrollView {
                
                LazyVGrid(columns: rows) {
                    if state.shoppingList == nil {
                        
                    } else {
                        ForEach(state.shoppingList?.items ?? [NaverShoppingItem(title: "", link: "", image: "", lprice: "", hprice: "", mallName: "", productId: "", productType: "", brand: "", maker: "", category1: "", category2: "", category3: "", category4: "")], id: \.self) { item in
                            
                            VStack {
                                ZStack(alignment: .bottomTrailing) {
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: UIScreen.screenWidth / 2 - 20, height: UIScreen.screenWidth / 2 - 20)
                                    ZStack(alignment: .center) {
                                        Circle()
                                            .background(.clear)
                                            .foregroundColor(.white)
                                            .frame(width: 32, height: 32)
                                            .padding(8)
                                        
                                        Button {
                                            print("버튼클릭")
                                        } label: {
                                            Image(systemName: "heart.fill")
                                                .background(.clear)
                                                .tint(.black)
                                        }
                                    }
                                }
                                
                                Text(item.mallName)
                                    .multilineTextAlignment(.leading)
                                Text(item.title)
                                Text(item.hprice)
                                    .bold()
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        SearchView.build(data: .init())
    }
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
