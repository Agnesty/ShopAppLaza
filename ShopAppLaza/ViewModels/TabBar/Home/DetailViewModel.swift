//
//  DetailViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 06/08/23.
//

import Foundation

class DetailViewModel {
    var detailViewCtr: DetailViewController?
    var loading: (() -> Void)?
//    var fungsi: ((Bool) -> Void)?
    
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
    
    func addToCart(productId: Int, sizeId: Int, accessTokenKey: String, completion: @escaping (Bool) -> Void) {
        print("post add")
        guard let unwrappedVC = detailViewCtr else { return }
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
        request.httpMethod = "POST"
        request.addValue("Bearer \(accessTokenKey)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Response: \(jsonResponse)")
                        
                        if let isError = jsonResponse["isError"] as? Int, isError != 0,
                           let description = jsonResponse["description"] as? String,
                           let status = jsonResponse["status"] as? String {
                            
                            DispatchQueue.main.async {
                                self.loading?()
                                unwrappedVC.showAlert(title: status, message: description) {
                                    completion(false)
                                }
                            }
                        } else {
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 201 {
                                DispatchQueue.main.async {
                                    self.loading?()
                                    unwrappedVC.showAlert(title: "Added to cart", message: "You have successfully added this product.") {
                                        completion(true)
                                    }
                                    print("BerhasilResponse: \(jsonResponse)")
                                }
                            } else {
                                print("Added to cart error: Unexpected Response Code")
                                completion(false)
                            }
                        }
                    }
                } catch {
                    print("JSON Serialization Error: \(error)")
                    completion(false)
                }
            }
        }.resume()
    }
    
}
