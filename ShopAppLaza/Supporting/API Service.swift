//
//  API Service.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 16/08/23.
//

import Foundation


enum APIServiceError: Error {
    case accessTokenNotFound
    case invalidURL
    // Add other error cases as needed
}
class APIService {
    
    let token = UserDefaults.standard.string(forKey: "accessToken")
    let refToken = UserDefaults.standard.string(forKey: "refreshToken")
    static func getHttpBodyRaw(param: [String:Any]) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        return jsonData
    }
    static func APIAddress(isMockApi: Bool) -> String {
        let baseUrl = isMockApi ? "http://localhost:3001/" : "https://lazaapp.shop/"
        return baseUrl
    }
//    static func refreshToken(isMockApi: Bool, refreshTokenKey: String) {
//        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
//        let refreshToken = EndpointPath.AuthRefreshToken.rawValue
//        let urlString = "\(baseUrl)\(refreshToken)"
//
//        guard let url = URL(string: urlString) else { print("Invalid URL.")
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = HttpMethod.GET.rawValue
//        request.addValue("Bearer \(refreshTokenKey)", forHTTPHeaderField: "X-Auth-Refresh")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            guard let data = data else {
//                print("Data is nil.")
//                return
//            }
//            do {
//                let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
//                print(result as Any)
//                if let data = result?["data"] as? [String: Any],
//                   let accessToken = data["access_token"] as? String {
//                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
//                }
//            } catch {
//                print("Error JSONSerialization: \(error)")
//
//            }
//        }.resume()
//    }
    
    

    static func refreshTokenAsync(isMockApi: Bool, refreshTokenKey: String, completion: @escaping (String) -> Void) {
        // Construct the URL
        let baseUrl = APIAddress(isMockApi: isMockApi)
        let refreshTokenPath = EndpointPath.AuthRefreshToken.rawValue
        guard let url = URL(string: baseUrl + refreshTokenPath) else {
            print("Error get url")
            return
        }
        
        // Create and configure the request
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET.rawValue
        request.addValue("Bearer \(refreshTokenKey)", forHTTPHeaderField: "X-Auth-Refresh")
        
        // Perform the network request asynchronously
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error: \(error?.localizedDescription ?? "")")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode != 200 {
                print("Error: \(httpResponse.statusCode)")
                return
            }
            // Parse the response data
            guard let data = data else { return }
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
                if let data = result?["data"] as? [String: Any],
                   let accessToken = data["access_token"] as? String,
                   let refreshToken = data["refresh_token"] as? String
                {
                    KeychainManager.keychain.saveToken(token: accessToken, service: Token.access.rawValue)
                    KeychainManager.keychain.saveToken(token: refreshToken, service: Token.refresh.rawValue)
                    completion(accessToken)
                } else {
                    throw APIServiceError.accessTokenNotFound
                }
            } catch {
                print("Error get access token")
            }
        }.resume()
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
    case AuthRefreshToken = "auth/refresh"
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
}

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
