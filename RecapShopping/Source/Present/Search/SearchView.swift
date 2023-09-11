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
        
    let rows = [GridItem(.flexible()), GridItem(.flexible())]
    let categoryLayout = [GridItem(.flexible())]
    
    let colors: [Color] = [.black, .blue, .brown, .cyan, .gray, .indigo, .mint, .yellow, .orange, .purple]
    
    let shoppingList = CurrentValueSubject<NaverShoppingList?, NetworkError>(nil)
    
    let tabCase: TabCase
    let productSearchUseCase: ProductSearchUseCase
    
    let category: [CategoryModel] = [CategoryModel(title: "정확도", isSelect: true), CategoryModel(title: "날짜순", isSelect: false), CategoryModel(title: "가격높은순", isSelect: false), CategoryModel(title: "가격낮은순", isSelect: false)]
    
    @Binding var searchText: String
    
    init(tabCase: TabCase, searchText: String, productSearchUseCase: ProductSearchUseCase) {
        self.productSearchUseCase = productSearchUseCase
        self.tabCase = tabCase
        self._searchText = .constant("")
    }
    
    var body: some View {
        var cancellable = Set<AnyCancellable>()
        
        VStack {
            Text("쇼핑 검색")
                .bold()
            HStack {
                ZStack {
                    
                    TextField("검색어를 입력하세요", text: $searchText)
                        .padding()
                        .padding(.horizontal, 25)
                        .background(Color.gray)
                        .cornerRadius(8)
                        
                    
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
            if tabCase == .search {
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
                .onAppear {
                    self.productSearchUseCase.excute(item: "감자")
                        .sink { error in
                            print(error)
                        } receiveValue: { receive in
                            print(receive)
                            self.shoppingList.send(receive)
                        }
                        .store(in: &cancellable)

                }
            }
            
            ScrollView {
                
                LazyVGrid(columns: rows) {
                    ForEach(colors, id: \.self) { color in
                        
                        VStack {
                            ZStack(alignment: .bottomTrailing) {
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: UIScreen.screenWidth / 2 - 20, height: UIScreen.screenWidth / 2 - 20)
                                    .foregroundColor(color)
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
                            
                            Text("월드캠핑카")
                                .multilineTextAlignment(.leading)
                            Text("스타리아 2층캠핑카")
                            Text("1900000")
                                .bold()
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
        let service = ServiceImpl.shared
        let productSearchRepositoryImpl = ProductSearchRepositoryImpl(service: service)
        let productSearchUseCaseImpl = ProductSearchUseCaseImpl(productSearchRepository: productSearchRepositoryImpl)
        SearchView(tabCase: .search, searchText: "cody", productSearchUseCase: productSearchUseCaseImpl)
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
