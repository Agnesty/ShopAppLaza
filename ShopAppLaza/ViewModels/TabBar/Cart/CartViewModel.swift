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
    
    func checkout(isMockApi: Bool, products: DataCart, addressId: Int, completion: @escaping ([OrderCheckout]) -> Void) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let order = EndpointPath.Order.rawValue
        let urlString = "\(baseUrl)\(order)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let userCart: [String: Any] = [
            "products": products,
            "address_id": addressId,
            "bank": "bni"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.POST.rawValue
        request.httpBody = APIService.getHttpBodyRaw(param: userCart)
        
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
                let orderProducts = try JSONDecoder().decode([OrderCheckout].self, from: data)
                
                DispatchQueue.main.async {
                    completion(orderProducts)
                    print("apakah ini orderProductSucces:", orderProducts)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                
            }
            
            
        }
    }
}
