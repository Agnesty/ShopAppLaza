//
//  API Service.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 16/08/23.
//

import Foundation
import JWTDecode

enum APIServiceError: Error {
    case accessTokenNotFound
    case invalidURL
    // Add other error cases as needed
}
class APIService {
    let token = KeychainManager.keychain.getToken(service: Token.access.rawValue)
    let refToken = KeychainManager.keychain.getToken(service: Token.refresh.rawValue)
    
    static func getHttpBodyRaw(param: [String:Any]) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        return jsonData
    }
    
    static func APIAddress(isMockApi: Bool) -> String {
        let baseUrl = isMockApi ? "http://localhost:3001/" : "https://lazaapp.shop/"
        return baseUrl
    }
    
    static func refreshToken(isMockApi: Bool, refreshTokenKey: String) async -> Bool {
        // Construct the URL
        let baseUrl = APIAddress(isMockApi: isMockApi)
        let refreshTokenPath = EndpointPath.AuthRefreshToken.rawValue
        guard let url = URL(string: baseUrl + refreshTokenPath) else {
            print("Error get url")
            return false
        }
        
        // Create and configure the request
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET.rawValue
        request.addValue("Bearer \(refreshTokenKey)", forHTTPHeaderField: "X-Auth-Refresh")
        
        // Perform the network request asynchronously
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return false }
            if httpResponse.statusCode != 200 {
                throw "Error: \(httpResponse.statusCode)" as! LocalizedError
            }
            let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
            if let data = result?["data"] as? [String: Any],
               let accessToken = data["access_token"] as? String,
               let refreshToken = data["refresh_token"] as? String
            {
                KeychainManager.keychain.saveToken(token: accessToken, service: Token.access.rawValue)
                KeychainManager.keychain.saveToken(token: refreshToken, service: Token.refresh.rawValue)
            } else {
                throw APIServiceError.accessTokenNotFound
            }
            return true
        } catch {
            print("Refresh token error: ", error.localizedDescription)
            return false
        }
    }
    
    func refreshTokenIfNeeded(completion: @escaping () -> Void, onError: ((String) -> Void)?) {
        guard let refreshToken = KeychainManager.keychain.getToken(service: Token.refresh.rawValue) else {
            print("Refresh token is nil")
            return
        }
        // Cek apakah token expired
        guard let jwt = try? decode(jwt: token!) else { return }
        if !jwt.expired { // jika tidak expired, run completion
            completion()
            return
        }
        // kalo expired, refresh dulu baru run completion
        Task {
            let isSuccess = await APIService.refreshToken(isMockApi: false, refreshTokenKey: refreshToken)
            isSuccess ? completion() : onError?("Error refresh token")
        }
    }
}



class Utils {
    static func setItemsWord(dataItem: Int) -> String {
        let countProduct = dataItem
        if countProduct == 0 || countProduct == 1 {
            return " item"
        } else if countProduct > 1 {
            return " items"
        } else {
            return " item"
        }
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
    case AuthRefreshToken = "auth/refresh"//UDAH
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
    case Wishlist = "wishlists"//UDAH
    // Credit Card
    case CreditCard = "credit-card"
    // Cart
    case Cart = "carts" //UDAH
    case Order = "order/bank" //UDAH
}

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
