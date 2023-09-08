//
//  User.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 29/07/23.
//

import Foundation

typealias User = UserElement

// MARK: - WelcomeElement
struct UserElement: Codable {
    let status: String
    let isError: Bool
    var data: DataUser
}

struct DataUser: Codable {
    let id: Int
    let fullName, username, email: String
    let imageUrl: String?
    let isVerified: Bool
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case username, email
        case imageUrl = "image_url"
        case isVerified = "is_verified"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}




