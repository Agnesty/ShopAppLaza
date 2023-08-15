//
//  Sizes.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 14/08/23.
//

import UIKit

typealias Sizes = SizesStatus?

struct SizesStatus: Codable {
    let status: String
    let isError: Bool
    let data: [DataSizes]
}

struct DataSizes: Codable {
    let id: Int
    let size: String
}
