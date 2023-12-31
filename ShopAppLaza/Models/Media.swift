//
//  File.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 20/08/23.
//

import UIKit

typealias Parameters = [String: String]

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "agnesimage.jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.3) else { return nil }
        self.data = data
    }
}

