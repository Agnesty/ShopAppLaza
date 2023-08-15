//
//  DetailViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 06/08/23.
//

import Foundation

class DetailViewModel {
//    let sizes = ["S", "M", "L", "XL", "2XL"]
    
    func getSizes(completion: @escaping (Sizes) -> Void) {
        guard let url = URL(string: "https://lazaapp.shop/size") else { print("Invalid URL.")
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
                let sizes = try JSONDecoder().decode(Sizes.self, from: data)
                DispatchQueue.main.async {
                    completion(sizes)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
}
