//
//  RefineItemDataBaseRepository.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/15.
//

import Foundation
import Combine

protocol RefineItemDataBaseRepository {
    func fetchItem() -> AnyPublisher<[RefineItem], Error> 
        
    func deleteItem(item: RefineItem)
    
    func addItem(item: RefineItem)
}
