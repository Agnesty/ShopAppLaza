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
    
    func increaseQuantityCart(productId: Int, sizeId: Int, accessTokenKey: String, completion: @escaping (Bool) -> Void) {
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
                        if let isError = jsonResponse["isError"] as? Int, isError != 0 {
                            DispatchQueue.main.async {
                                self.loading?()
                                completion(false)
                            }
                        } else {
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 201 {
                                print("BerhasilResponse: \(jsonResponse)")
                                DispatchQueue.main.async {
                                    self.loading?()
                                    completion(true)
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
    
    func decreaseQuantityCart(productId: Int, sizeId: Int, accessTokenKey: String, completion: @escaping (Bool) -> Void) {
        print("kepanggil nih")
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
        request.httpMethod = "PUT"
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
                        if let isError = jsonResponse["isError"] as? Int, isError != 0 {
                            DispatchQueue.main.async {
                                self.loading?()
                                completion(false)
                            }
                        } else {
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                                print("BerhasilResponse: \(jsonResponse)")
                                DispatchQueue.main.async {
                                    self.loading?()
                                    completion(true)
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
    
    func deleteProductCart(productId: Int, sizeId: Int, accessTokenKey: String, completion: @escaping (Bool) -> Void) {
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
                                   unwrappedVC.showAlert(title: "Cart Update", message: data) {
                                       print("Status Check:", status)
                                       completion(status == "OK")
                                   }
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
