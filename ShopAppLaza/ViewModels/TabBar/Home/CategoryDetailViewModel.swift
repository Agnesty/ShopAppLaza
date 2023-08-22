//
//  CategoryDetailViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 21/08/23.
//

import Foundation

class CategoryDetailViewModel {
    var categoryDetailVC: CategoryDetailView?
    
    func getCategoryDetailById(id: Int, completion: @escaping (DetailBrand) -> Void) {
        guard let url = URL(string: "https://lazaapp.shop/brand/\(id)") else { print("Invalid URL.")
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
                let detailBrand = try JSONDecoder().decode(DetailBrand.self, from: data)
                DispatchQueue.main.async {
                    completion(detailBrand)
                }
            } catch {
                print("Error decoding JSON: \(error)")
             
            }
        }.resume()
    }
}
