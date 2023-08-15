//
//  Product.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 27/07/23.
//

import Foundation
import UIKit

typealias Welcome = ProductStatus?

struct ProductStatus: Codable {
    let status: String
    let isError: Bool
    let data: [WelcomeElement]
}

struct WelcomeElement: Codable {
    let id: Int
    let name: String
    let image_url: String
    let price: Double
    let created_at: String
}

enum Star: String {
    case fullStar = "star.fill"
    case halfStar = "star.leadinghalf.filled"
    case emptyStar = "star"
}


