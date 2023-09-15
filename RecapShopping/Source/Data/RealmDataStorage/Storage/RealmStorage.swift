//
//  RealmStorage.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/14.
//

import Foundation
import RealmSwift

final class RealmStorage {
    static let shared = RealmStorage()
    private init() {}
    private let realm = try! Realm()
    
    func addItem(item: ItemRealmDTO) {
        try? realm.write {
            realm.add(item)
        }
    }
    
    func deleteItem(item: ItemRealmDTO) {
        try? realm.write {
            realm.delete(item)
        }
    }
}
