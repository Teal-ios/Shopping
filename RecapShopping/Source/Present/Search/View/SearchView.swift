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
    
    let category: [CategoryModel] = [CategoryModel(title: "정확도", isSelect: true), CategoryModel(title: "날짜순", isSelect: false), CategoryModel(title: "가격높은순", isSelect: false), CategoryModel(title: "가격낮은순", isSelect: false)]
    
    @State var searchText: String = ""
    
    var body: some View {
        bodyView()
            .onAppear(perform: intent.viewOnAppear)
            .navigationBarTitle(state.navigationTitle, displayMode: .inline)
            .modifier(SearchRouter(subjects: state.routerSubject, intent: intent))
            .foregroundColor(.black)
    }
}

private extension SearchView {
    func bodyView() -> some View {
        return VStack {
            Text("쇼핑 검색")
                .bold()
            textFieldView()
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
            
            shoppingListScrollerView()
                .background(Color.black)
        }
        .background(Color.black)
    }
}

extension SearchView {
    func textFieldView() -> some View {
        
        return HStack {
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
            .foregroundColor(.white)
        }
        .padding()
    }
}

extension SearchView {
    func shoppingListScrollerView() -> some View {
        ScrollView {
            
            LazyVGrid(columns: rows) {
                if state.shoppingList == nil {
                    
                } else {
                    ForEach(state.itemDTOList, id: \.self) { item in
                        VStack {
                            ZStack(alignment: .bottomTrailing) {
                                 
                                Image(uiImage: item.image)
                                    .resizable()
                                    .frame(width: UIScreen.screenWidth / 2 - 20, height: UIScreen.screenWidth / 2 - 20)
                                    .clipped()
                                    .cornerRadius(10)
                                
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
                            
                            Text("[\(item.mallName)]")
                                .foregroundColor(Color.gray)
                            Text(item.title)
                                .foregroundColor(Color.white)
                                .lineLimit(2)
                            Text(item.lprice)
                                .bold()
                                .foregroundColor(Color.white)
                        }
                    }
                }
            }
        }
        .padding()
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
