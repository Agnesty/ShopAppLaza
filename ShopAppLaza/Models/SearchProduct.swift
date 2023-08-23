//
//  SearchProduct.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 22/08/23.
//

import Foundation

// MARK: - SearchProduct
struct SearchProduct: Codable {
    let status: String
    let isError: Bool
    let data: [DataSearch]
}

// MARK: - Datum
struct DataSearch: Codable {
    let id: Int
    let name: String
    let imageURL: String
    let price: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
        case price
        case createdAt = "created_at"
    }
}
