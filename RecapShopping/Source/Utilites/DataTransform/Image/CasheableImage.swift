//
//  CasheableImage.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/13.
//

import Foundation

final class CacheableImage {
    let imageData: Data
    let cacheInfo: CacheInfo

    init(imageData: Data, etag: String) {
        self.cacheInfo = CacheInfo(etag: etag, lastRead: Date())
        self.imageData = imageData
    }
}

struct CacheInfo: Codable {
    let etag: String
    let lastRead: Date
}
