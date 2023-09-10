//
//  NetworkError.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import Foundation

enum NetworkError: Error {
    case unexpectedData
    case decodingError
    case clientError
    case serverError
    case internalError
}
