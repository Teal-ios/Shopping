//
//  Router.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import Foundation

enum Router {
    case shopping(parameters: NaverShoppingQuery)
}

extension Router: TargetType {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "openapi.naver.com/\(APIKey.verson)"
    }

    var path: String {
        switch self {
        case .shopping: return "/search/shop.json"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .shopping(let parameters):
            return [URLQueryItem(name: "query", value: parameters.query)]
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var header: [String: String] {
        switch self {
        default:
            return ["Content-Type":"application/x-www-form-urlencoded; charset=UTF-8", "X-Naver-Client-Id":APIKey.naverShoppingClientKey, "X-Naver-Client-Secret":APIKey.naverShoppingSecretKey]
            //"Accept-Version": "v1" 이거 추가해보기 통신되면
        }
    }

    var parameters: String? {
        return nil
    }
}
