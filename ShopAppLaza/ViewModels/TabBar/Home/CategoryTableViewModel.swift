//
//  ForgotPasswordViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 06/08/23.
//

import Foundation

class CategoryTableViewModel {
    var categoryTableViewCell: CategoryTableViewCell?
    
    func getDataCategories(completion: @escaping (Categories) -> Void) {
        guard let url = URL(string: "https://fakestoreapi.com/products/categories") else { print("Invalid URL.")
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
                let categories = try JSONDecoder().decode(Categories.self, from: data)
                DispatchQueue.main.async {
                    completion(categories)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
