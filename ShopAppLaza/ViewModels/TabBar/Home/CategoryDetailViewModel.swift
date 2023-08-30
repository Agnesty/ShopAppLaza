//
//  CategoryDetailViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 21/08/23.
//

import Foundation

class CategoryDetailViewModel {
    func getDetailBrandById(isMockApi: Bool, name: String, completion: @escaping (ProductBrand) -> Void) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let productsByBrand = EndpointPath.ProductsByBrand.rawValue
        let urlString = "\(baseUrl)\(productsByBrand)"
        guard var components = URLComponents(string: urlString) else { print("Invalid URL.")
            return
        }
        components.queryItems = [
            URLQueryItem(name: "name", value: "\(name)")
        ]
        guard let url = components.url else {
            print("Invalid URL components.")
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
