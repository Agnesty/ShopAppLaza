//
//  CardModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/09/23.
//

import Foundation

struct CardModel: Codable {
    var userId: Int
    var ownerCard: String
    var numberCard: String
    var cvvCard: String
    var expMonthCard: String
    var expYearCard: String
}
