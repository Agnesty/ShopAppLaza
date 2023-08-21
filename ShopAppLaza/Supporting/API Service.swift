//
//  API Service.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 16/08/23.
//

import Foundation

class APIService {
    let token = UserDefaults.standard.string(forKey: "accessToken")
    static func getHttpBodyRaw(param: [String:Any]) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        return jsonData
    }
}

class DateTimeUtils {
    static let shared = DateTimeUtils()
    
    private let formatter = DateFormatter()
    
    func formatReview(date: String) -> String {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let formattedDate = formatter.date(from: date) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: formattedDate)
        }
        return date
    }
}
