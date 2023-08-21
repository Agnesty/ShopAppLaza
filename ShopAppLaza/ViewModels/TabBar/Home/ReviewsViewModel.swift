//
//  ReviewsViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 14/08/23.
//

import Foundation

class ReviewsViewModel {
    func getAllReviews(id: Int, completion: @escaping (AllReviews) -> Void) {
        guard let url = URL(string: "https://lazaapp.shop/products/\(id)/reviews") else { print("Invalid URL.")
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
                let detailProducts = try JSONDecoder().decode(AllReviews.self, from: data)

                DispatchQueue.main.async {
                    completion(detailProducts)
                }
            } catch {
                print("Error decoding JSON: \(error)")
             
            }
        }.resume()
    }
}
