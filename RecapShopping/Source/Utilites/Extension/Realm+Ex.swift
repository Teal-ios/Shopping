//
//  Realm+Ex.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/15.
//

import Foundation
import RealmSwift

extension Results {
    var toArray: [Element] {
        return compactMap { $0 }
    }
}
