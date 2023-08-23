//
//  CartTableViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 22/08/23.
//

import Foundation

class CartTableViewModel {
    var cartTableVC: CartViewController?
    var loading: (() -> Void)?
    
    func deleteProductCart(productId: Int, sizeId: Int, accessTokenKey: String) {
        print("awalan")
        guard let unwrappedVC = cartTableVC else { return }
        guard var components = URLComponents(string: "https://lazaapp.shop/carts") else {
            print("Invalid URL.")
            return
        }
        components.queryItems = [
            URLQueryItem(name: "ProductId", value: "\(productId)"),
            URLQueryItem(name: "SizeId", value: "\(sizeId)")
        ]
        guard let url = components.url else {
            print("Invalid URL components.")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(accessTokenKey)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                           if let data = jsonResponse["data"] as? String,
                            let status = jsonResponse["status"] as? String {
                               DispatchQueue.main.async {
                                   self.loading?()
                                   unwrappedVC.showAlert(title: "Cart Update", message: data)
                                   print("Status Check:", status)
                               }
                           }
                       }
                } catch {
                    print("JSON Serialization Error: \(error)")
                }
            }
        }.resume()
    }
}
