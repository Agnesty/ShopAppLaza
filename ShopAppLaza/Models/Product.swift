//
//  Product.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 27/07/23.
//

import Foundation
import UIKit

typealias Welcome = [WelcomeElement]
typealias Categories = [String]

// MARK: - WelcomeElement
struct WelcomeElement: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: Category
    let image: String
    let rating: Rating
}

enum Category: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double
    let count: Int
}

enum Star: String {
    case fullStar = "star.fill"
    case halfStar = "star.leadinghalf.filled"
    case emptyStar = "star"
}


