//
//  AllReviews.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 18/08/23.
//

import Foundation

// MARK: - AllReviews
struct AllReviews: Codable {
    let status: String
    let isError: Bool
    let data: DataAllReviews
}

// MARK: - DataAllReviews
struct DataAllReviews: Codable {
    let ratingAvrg: Double
    let total: Int
    let reviews: [ReviewAll]

    enum CodingKeys: String, CodingKey {
        case ratingAvrg = "rating_avrg"
        case total, reviews
    }
}

// MARK: - ReviewAll
struct ReviewAll: Codable {
    let id: Int
    let comment: String
    let rating: Double
    let fullName: String
    let imageURL: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, comment, rating
        case fullName = "full_name"
        case imageURL = "image_url"
        case createdAt = "created_at"
    }
}
