//
//  CartViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 22/08/23.
//

import Foundation

class CartViewModel {
    var loading: (() -> Void)?
    var navigateToHome: (() -> Void)?
    var navigateToVerifyEmail: (() -> Void)?
    var presentAlert: ((String, String, (() -> Void)?) -> Void)?
    
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
    
    func checkout(isMockApi: Bool, accessTokenKey: String, products: [DataProductCheckout], addressId: Int, bank: String) {
        print("Calling checkout function")
        
        // Construct the base URL
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let orderEndpoint = EndpointPath.Order.rawValue
        let urlString = "\(baseUrl)\(orderEndpoint)"
        
        // Validate the URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create and configure the request
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.POST.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessTokenKey)", forHTTPHeaderField: "X-Auth-Token")
        
        // Serialize the request body
        do {
            let checkout = Checkout(products: products, addressId: addressId, bank: bank)
            let jsonData = try JSONEncoder().encode(checkout)
            request.httpBody = jsonData
        } catch {
            print("Error encoding userCart to JSON: \(error)")
            return
        }
        
        // Perform the HTTP request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Response: \(jsonResponse)")
                        if let isError = jsonResponse["isError"] as? Bool, isError,
                           let description = jsonResponse["description"] as? String,
                           let status = jsonResponse["status"] as? String {
                            
                            DispatchQueue.main.async { [weak self] in
                                self?.loading?()
                                self?.presentAlert?(status, description, nil)
                            }
                        } else {
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 201 {
                                DispatchQueue.main.async { [weak self] in
                                    self?.loading?()
                                    self?.navigateToHome?()
                                    print("Successful Response: \(jsonResponse)")
                                }
                            } else {
                                print("Checkout Code Error: Unexpected Response Code")
                            }
                        }
                    }
                } catch {
                    print("JSON Serialization Error: \(error)")
                }
            }
        }
        
        task.resume()
    }


}
