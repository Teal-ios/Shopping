//
//  ImageLoader.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/12.
//

import SwiftUI

//class ImageLoader: ObservableObject {
//    @Published var image: UIImage?
//
//    private var url: String
//    private var task: URLSessionDataTask?
//
//    init(url: String) {
//        self.url = url
//        loadImage()
//    }
//
//    private func loadImage() {
//        if let cachedImage = ImageCache.shared.get(forKey: url) {
//            self.image = cachedImage
//            return
//        }
//
//        guard let url = URL(string: url) else { return }
//
//        task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//
//            DispatchQueue.main.async {
//                let image = UIImage(data: data)
//                self.image = image
//                ImageCache.shared.set(image!, forKey: self.url)
//            }
//        }
//        task?.resume()
//    }
//}
