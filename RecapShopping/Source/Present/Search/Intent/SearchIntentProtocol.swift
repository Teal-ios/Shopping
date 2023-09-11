//
//  SearchIntentProtocol.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

import Foundation

protocol SearchIntentProtocol {
    func viewOnAppear()
    func searchKeyboardButtonTapped()
    func searchTextToIntent(text: String)
}
