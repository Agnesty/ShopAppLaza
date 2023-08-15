//
//  Brand.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 14/08/23.
//

import UIKit

typealias Brand = BrandStatus?

struct BrandStatus: Codable {
    let status: String
    let isError: Bool
    let description: [DescriptionBrand]
}

struct DescriptionBrand: Codable {
    let id: Int
    let name: String
    let logo_url: String
}
