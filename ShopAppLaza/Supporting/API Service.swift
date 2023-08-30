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
    static func APIAddress(isMockApi: Bool) -> String {
        let baseUrl = isMockApi ? "http://localhost:3001/" : "https://lazaapp.shop/"
        return baseUrl
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

enum EndpointPath: String {
    // Authentication
    case Login = "login" //UDAH
    case Register = "register" //UDAH
    case AuthForgotPassword = "auth/forgotpassword" //UDAH
    case AuthVerificationCode = "auth/recover/code" //UDAH
    case NewPassword = "auth/recover/password" //UDAH
    case AuthResendVerify = "auth/confirm/resend" //UDAH
    // Products
    case Products = "products" //UDAH
    case Brands = "brand"//UDAH
    case ProductsByBrand = "products/brand"//UDAH
    case ProductSize = "size"//UDAH
    // User
    case UserProfile = "user/profile" //UDAH
    case UserUpdate = "user/update" //USAH
    case UserChangePassword = "user/change-password"
    case Users = "user"
    // Address
    case Address = "address"//UDAH
    // Wishlist
    case Wishlist = "wishlists"
    // Credit Card
    case CreditCard = "credit-card"
    // Cart
    case Cart = "carts" //UDAH
}

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
