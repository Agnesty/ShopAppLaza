//
//  CartTableViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 22/08/23.
//

import Foundation

class CartTableViewModel {
    var loading: (() -> Void)?
    var presentAlert: ((String, String, (() -> Void)?) -> Void)?
    
    func increaseQuantityCart(isMockApi: Bool, productId: Int, sizeId: Int, accessTokenKey: String, completion: @escaping (Bool) -> Void) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let cart = EndpointPath.Cart.rawValue
        let urlString = "\(baseUrl)\(cart)"
        guard var components = URLComponents(string: urlString) else {
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
        request.httpMethod = HttpMethod.POST.rawValue
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
    
    func decreaseQuantityCart(isMockApi: Bool, productId: Int, sizeId: Int, accessTokenKey: String, completion: @escaping (Bool) -> Void) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let cart = EndpointPath.Cart.rawValue
        let urlString = "\(baseUrl)\(cart)"
        guard var components = URLComponents(string: urlString) else {
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
        request.httpMethod = HttpMethod.PUT.rawValue
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
    
    func deleteProductCart(isMockApi: Bool, productId: Int, sizeId: Int, accessTokenKey: String, completion: @escaping (Bool) -> Void) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let cart = EndpointPath.Cart.rawValue
        let urlString = "\(baseUrl)\(cart)"
        guard var components = URLComponents(string: urlString) else {
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
        request.httpMethod = HttpMethod.DELETE.rawValue
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
                               DispatchQueue.main.async { [weak self] in
                                   self?.loading?()
                                   self?.presentAlert?("Cart Update", data, {
                                       print("Status Check:", status)
                                       completion(status == "OK")
                                   })
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
