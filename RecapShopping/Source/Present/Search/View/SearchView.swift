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
                .foregroundColor(Color.white)
            textFieldView()
            if container.model.tabCase == .search {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(state.category, id: \.self) { category in
                            if category.isSelect == true {
                                Button {
                                    print("카테고리클릭")
                                } label: {
                                    Text(category.title)
                                        .frame(height: 32)
                                        .foregroundColor(.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray,lineWidth:1)
                                        )
                                }
                                .background(Color.white)
                                .cornerRadius(8)
                            } else {
                                Button {
                                    print("카테고리클릭")
                                } label: {
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
                    .frame(height: 36)
                    .padding(.horizontal, 40)
                    .background(Color(uiColor: UIColor(red: 28/255, green: 28/255, blue: 31/255, alpha: 1.0)))
                    .cornerRadius(8)
                    .keyboardType(.default)
                    .onSubmit {
                        intent.searchTextToIntent(text: searchText)
                        intent.searchKeyboardButtonTapped()
                    }
                    .foregroundColor(Color.white)
                
                
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding([.leading])
                        .foregroundColor(Color(uiColor: UIColor.lightGray))
                    
                    Spacer()
                    
                    Button {
                        print("button")
                    } label: {
                        Image(systemName: "x.circle.fill")
                    }
                    .padding([.trailing])
                    .foregroundColor(Color(uiColor: UIColor.lightGray))
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
                if state.refineItemList.count == 0 {
                    
                } else {
                    ForEach(state.refineItemList, id: \.self) { item in
                        VStack {
                            ZStack(alignment: .bottomTrailing) {
                                
                                Image(uiImage: UIImage(data: item.image) ?? UIImage())
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
                                        if item.isSelected {
                                            Image(systemName: "heart.fill")
                                                .background(.clear)
                                                .tint(.black)
                                        } else {
                                            Image(systemName: "heart")
                                                .background(.clear)
                                                .tint(.black)
                                        }
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

