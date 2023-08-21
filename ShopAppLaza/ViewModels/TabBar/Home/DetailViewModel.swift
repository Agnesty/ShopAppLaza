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
    
}
