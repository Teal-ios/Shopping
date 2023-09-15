//
//  ImageCacheError.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/13.
//

import Foundation

enum ImageCacheError: Error {
    case nilPathError
    case nilImageError
    case invalidURLError
    case imageNotModifiedError
    case networkUsageExceedError
    case unknownNetworkError
}
