//
//  DetailViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 06/08/23.
//

import Foundation

class DetailViewModel {
    
    func getDetailProductById(id: Int, completion: @escaping (DetailProduct) -> Void) {
        guard let url = URL(string: "https://lazaapp.shop/products/\(id)") else { print("Invalid URL.")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Data is nil.")
                return
            }
            do {
                let detailProducts = try JSONDecoder().decode(DetailProduct.self, from: data)

                DispatchQueue.main.async {
                    completion(detailProducts)
                }
            } catch {
                print("Error decoding JSON: \(error)")
             
            }
        }.resume()
    }
    
    func putFavorite(accessTokenKey: String, productId: Int, completion: @escaping (UpdateWishlist) -> Void) {
        guard var components = URLComponents(string: "https://lazaapp.shop/wishlists") else {
            print("Invalid URL.")
            return
        }
        components.queryItems = [
            URLQueryItem(name: "ProductId", value: "\(productId)")
        ]
        guard let url = components.url else {
            print("Invalid URL components.")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(accessTokenKey)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Data is nil.")
                return
            }
            do {
                let detailWishlist = try JSONDecoder().decode(UpdateWishlist.self, from: data)
                
                DispatchQueue.main.async {
                    completion(detailWishlist)
                    print("apakah detailWishlist bisa:", detailWishlist)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
}
