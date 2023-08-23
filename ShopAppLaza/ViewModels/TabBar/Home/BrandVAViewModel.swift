//
//  BrandVAViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 22/08/23.
//

import Foundation

class BrandVAViewModel {
    var brandVAVC: BrandVAViewController?
    
    func getDetailProductById(name: String, completion: @escaping (ProductBrand) -> Void) {
        guard let url = URL(string: "https://lazaapp.shop/products/brand?name=\(name)") else { print("Invalid URL.")
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
                let detailProducts = try JSONDecoder().decode(ProductBrand.self, from: data)

                DispatchQueue.main.async {
                    completion(detailProducts)
                }
            } catch {
                print("Error decoding JSON: \(error)")
             
            }
        }.resume()
    }
}
