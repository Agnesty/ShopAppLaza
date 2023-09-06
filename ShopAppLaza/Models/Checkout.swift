//
//  Checkout.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 06/09/23.
//

import Foundation

struct Checkout: Codable {
    let products: [DataProductCheckout]
    let addressId: Int
    let bank: String
    
    private enum CodingKeys: String, CodingKey {
        case products = "products"
        case addressId = "address_id"
        case bank = "bank"
    }
}

struct DataProductCheckout: Codable {
    let id: Int
    let quantity: Int
}
