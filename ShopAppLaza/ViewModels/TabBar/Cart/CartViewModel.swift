//
//  CartViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 22/08/23.
//

import Foundation

class CartViewModel {
    func getProducInCart(isMockApi: Bool, accessTokenKey: String, completion: @escaping (CartProduct) -> Void) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let cart = EndpointPath.Cart.rawValue
        let urlString = "\(baseUrl)\(cart)"
        guard let url = URL(string: urlString) else {
            print("Invalid url.")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessTokenKey)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            guard let data = data else {
                print("Data is nil.")
                return
            }
            do {
                let cartProducts = try JSONDecoder().decode(CartProduct.self, from: data)
                
                DispatchQueue.main.async {
                    completion(cartProducts)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                
            }
        }.resume()
        
    }
    
    func getAllSize(isMockApi: Bool, completion: @escaping (AllSize) -> Void) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let size = EndpointPath.ProductSize.rawValue
        let urlString = "\(baseUrl)\(size)"
        guard let url = URL(string: urlString) else {
            print("Invalid url.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            guard let data = data else {
                print("Data is nil.")
                return
            }
            do {
                let sizeProducts = try JSONDecoder().decode(AllSize.self, from: data)
                
                DispatchQueue.main.async {
                    completion(sizeProducts)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                
            }
        }.resume()
    }
}
